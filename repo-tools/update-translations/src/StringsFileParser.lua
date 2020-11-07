---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local stringx = require "pl.stringx"
local tablex = require "pl.tablex"

---
-- Parses given strings_*.cfg files.
--
-- @type StringsFileParser
--
local StringsFileParser = Object:extend()


-- The available string file section types
StringsFileParser.SECTION_TYPE_STRING_ALIAS = 1
StringsFileParser.SECTION_TYPE_REMAINING_CODE = 2

---
-- The extracted string alias sections
-- These are lines where strings aliases are defined (Something like `const messageA "somestring";`)
--
-- @tfield string[][] stringAliasSections
--
StringsFileParser.stringAliasSections = nil

---
-- The extracted string alias names
--
-- @tfield string[] stringAliasNames
--
StringsFileParser.stringAliasNames = nil

---
-- The extracted remaining code sections
-- These are lines where anything other than string alias definitions are done
--
-- @tfield string[][] remainingCodeSections
--
StringsFileParser.remainingCodeSections = nil

---
-- The order in which the STRING_ALIAS and REMAINING_CODE sections were found in the file
--
-- @tfield int[] sections
--
StringsFileParser.sections = nil


---
-- StringsFileParser constructor.
--
function StringsFileParser:new()
  self.stringAliasSections = {}
  self.stringAliasNames = {}
  self.remainingCodeSections = {}
  self.sections = {}
end


-- Public Methods

---
-- Parses a given file.
--
-- @tparam string _stringsFilePath The path to the file to parse
--
function StringsFileParser:parse(_stringsFilePath)

  local currentStringAlias = nil
  local doCheckStringAliasNestingLevel = false
  local currentStringAliasNestingLevel = 0

  local currentSectionOutputLines = {}
  table.insert(self.remainingCodeSections, currentSectionOutputLines)
  table.insert(self.sections, self.SECTION_TYPE_REMAINING_CODE)

  for line in io.lines(_stringsFilePath) do

    if (currentStringAlias == nil) then
      currentStringAlias = line:match("^const ([^ ]+)")
      if (currentStringAlias) then
        currentSectionOutputLines = {}
        table.insert(self.stringAliasNames, currentStringAlias)
        table.insert(self.stringAliasSections, currentSectionOutputLines)
        table.insert(self.sections, self.SECTION_TYPE_STRING_ALIAS)
        doCheckStringAliasNestingLevel = (line:match("^const [^ ]+ +%[") ~= nil or line:match("^const [^ ]+ +%(format +%[") ~= nil)
        currentStringAliasNestingLevel = 0
      end
    end

    table.insert(currentSectionOutputLines, line)

    if (currentStringAlias ~= nil) then
      if (doCheckStringAliasNestingLevel) then
        currentStringAliasNestingLevel = self:calculateMultiLineStringDefinitionNestingLevel(line, currentStringAliasNestingLevel)
      end

      if (currentStringAliasNestingLevel == 0) then
        currentSectionOutputLines = {}
        table.insert(self.remainingCodeSections, currentSectionOutputLines)
        table.insert(self.sections, self.SECTION_TYPE_REMAINING_CODE)
        currentStringAlias = nil
      end
    end

  end

end

---
-- Returns all string alias names that were found in the last parsed file.
--
-- @treturn string[] The list of string alias names
--
function StringsFileParser:getStringAliasNames()
  return self.stringAliasNames
end

---
-- Returns a iterator that can be used in a `for in` loop to iterate over all sections.
--
-- The key will be either
-- * StringsFileParser.SECTION_TYPE_REMAINING_CODE if the section is a "remaining code" section
-- * A string alias name if the section is a "string alias" section
--
-- The value will be a list of lines
--
-- @treturn function The iterator function
--
function StringsFileParser:getSections()

  local stringAliasNumber = 0
  local remainingCodeNumber = 0
  local currentSectionNumber = 0
  local numberOfSections = #self.sections

  return function()

    local sectionType, sectionName, section

    currentSectionNumber = currentSectionNumber + 1
    if (currentSectionNumber > numberOfSections) then
      return nil
    else
      sectionType = self.sections[currentSectionNumber]

      if (sectionType == self.SECTION_TYPE_REMAINING_CODE) then
        sectionName = self.SECTION_TYPE_REMAINING_CODE
        remainingCodeNumber = remainingCodeNumber + 1
        section = self.remainingCodeSections[remainingCodeNumber]
      else
        stringAliasNumber = stringAliasNumber + 1
        sectionName = self.stringAliasNames[stringAliasNumber]
        section = self.stringAliasSections[stringAliasNumber]
      end

      return sectionName, section

    end

  end

end

---
-- Returns the "remaining code" section before a given string alias definition.
--
-- @tparam string _stringAliasName The string alias name
--
-- @treturn string[]|nil The "remaining code" section
--
function StringsFileParser:getRemainingCodeSectionBefore(_stringAliasName)

  local stringAliasNumber = tablex.find(self.stringAliasNames, _stringAliasName)
  if (stringAliasNumber and self.stringAliasSections[stringAliasNumber] ~= nil) then

    local sectionTypesString = table.concat(self.sections, "")
    stringx.replace(sectionTypesString, "" .. self.SECTION_TYPE_STRING_ALIAS, "", stringAliasNumber - 1)

    local aliasSectionIndex = sectionTypesString:find(self.SECTION_TYPE_STRING_ALIAS)
    if (aliasSectionIndex ~= nil and aliasSectionIndex > 1) then
      return self.remainingCodeSections[aliasSectionIndex - 1]
    end

  end

  return nil

end

---
-- Returns the "string alias" section for a given string alias name.
--
-- @tparam string _stringAliasName The string alias name
--
-- @treturn string[]|nil The "string alias" section
--
function StringsFileParser:getStringAliasSection(_stringAliasName)

  local aliasIndex = tablex.find(self.stringAliasNames, _stringAliasName)
  if (aliasIndex ~= nil) then
    return self.stringAliasSections[aliasIndex]
  else
    return nil
  end

end


-- Private Methods

---
-- Calculates and returns the nesting level of a multi line string definition with square brackets in a given line.
--
-- @tparam string _line The line to calculate the nesting level from
-- @tparam int _nestingLevel The initial nesting level
--
-- @treturn int The calculated nesting level
--
function StringsFileParser:calculateMultiLineStringDefinitionNestingLevel(_line, _nestingLevel)

  local nestingLevel = _nestingLevel
  local lineOffset = 0
  local nextSquareBracketPosition, nextSquareBracketType
  while (true) do

    nextSquareBracketPosition = _line:find("[%[%]]", lineOffset)
    if (nextSquareBracketPosition == nil) then
      break
    end

    nextSquareBracketType = _line:sub(nextSquareBracketPosition, nextSquareBracketPosition)
    if (nextSquareBracketType == "[") then
      nestingLevel = nestingLevel + 1
    else
      nestingLevel = nestingLevel - 1
    end

    lineOffset = nextSquareBracketPosition + 1

  end

  return nestingLevel

end


return StringsFileParser
