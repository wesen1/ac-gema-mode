---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local ExtractedFunction = require "src.Extractor.ExtractedFunction"
local ExtractedVariable = require "src.Extractor.ExtractedVariable"

local DocumentableContentsExtractor = Object:extend()


---
-- The list of identifiers that should not be documented
--
-- @tfield string[] undocumentableIdentifiers
--
DocumentableContentsExtractor.undocumentableIdentifiers = {
  -- Builtin event handlers
  "mapstartalways", "onQuit", "onSpawn", "onKill", "onFlag", "onAttack", "start_intermission", "onNewMap"
}

---
-- The patterns for identifier definitions
--
-- @tfield string[] identifierDefinitionPatterns
--
DocumentableContentsExtractor.identifierDefinitionPatterns = {

  -- <identifier> = value
  "\n? *([^ \n]+) *= *",

  "\n? *alias +([^ \n]+) *",
  "\n? *const +([^ \n]+) *",
  "\n? *function +([^ \n]+) *",
  "\n? *event +([^ \n]+) *",
  "\n? *eventlistener +([^ \n]+) *",
  "\n? *checkinit +([^ \n]+) *",
  "\n? *check2init +([^ \n]+) *",
  "\n? *cache +([^ \n]+) *",
  "\n? *option +([^ \n]+) *"
}

---
-- The extracted variables
--
-- @tfield ExtractedVariable[] extractedVariables
--
DocumentableContentsExtractor.extractedVariables = nil

---
-- The extracted functions
--
-- @tfield ExtractedFunction[] extractedFunctions
--
DocumentableContentsExtractor.extractedFunctions = nil


---
-- DocumentableContentsExtractor constructor.
--
function DocumentableContentsExtractor:new()
  self.extractedVariables = {}
  self.extractedFunctions = {}
end


-- Getters and Setters

---
-- Returns the extracted variables.
--
-- @treturn ExtractedVariable[] The extracted variables
--
function DocumentableContentsExtractor:getExtractedVariables()
  return self.extractedVariables
end

---
-- Returns the extracted functions.
--
-- @treturn ExtractedFunction[] The extracted functions
--
function DocumentableContentsExtractor:getExtractedFunctions()
  return self.extractedFunctions
end


-- Public Methods

---
-- Extracts all documentable contents from a specified file.
--
-- @tparam File _file The file to extract all documentable contents from
--
function DocumentableContentsExtractor:extractDocumentableContentsFromFile(_file)

  local currentStringOffset

  local fileContents = _file:getContents()
  local nextPattern, nextPatternPosition

  repeat

    nextPattern, nextPatternPosition = self:findNextPattern(fileContents, currentStringOffset)
    if (nextPattern) then

      local identifierName = fileContents:match(nextPattern, currentStringOffset)
      local isDocumentableIdentifier = true
      for _, undocumentableIdentifier in ipairs(self.undocumentableIdentifiers) do
        if (undocumentableIdentifier == identifierName) then
          isDocumentableIdentifier = false
          break
        end
      end

      local previousCode = fileContents:sub(1, nextPatternPosition["start"]):reverse()


      if (previousCode:find("^ *[^\n]+")) then
        -- The found pattern is not at the start of a line, its probably inside a comment or string
        isDocumentableIdentifier = false
      end

      if (self:isNextIdentifierFunction(fileContents, nextPattern, nextPatternPosition["start"])) then
        currentStringOffset = self:extractFunction(
          fileContents,
          nextPattern,
          nextPatternPosition["start"],
          nextPatternPosition["end"],
          isDocumentableIdentifier
        )
      else
        currentStringOffset = self:extractVariable(
          fileContents,
          nextPattern,
          nextPatternPosition["start"],
          nextPatternPosition["end"],
          isDocumentableIdentifier
        )
      end
    end

  until (not nextPattern)

end


-- Private Methods

---
-- Finds and returns the next occurrence of one of the identifier definition patterns.
-- Will return nil, nil if no pattern was found.
--
-- @tparam string _fileContents The file contents to search for patterns
-- @tparam int _stringOffset The string offset
--
-- @treturn string, table The next pattern and a table with the field "start" and "end"
--
function DocumentableContentsExtractor:findNextPattern(_fileContents, _stringOffset)

  local patternStartPosition, patternEndPosition
  local closestPattern, closestPatternPosition

  for _, pattern in ipairs(self.identifierDefinitionPatterns) do

    patternStartPosition, patternEndPosition = _fileContents:find(pattern, _stringOffset)
    if (patternStartPosition) then

      if (not closestPattern or closestPatternPosition["start"] > patternStartPosition) then
        closestPattern = pattern
        closestPatternPosition = {
          ["start"] = patternStartPosition,
          ["end"] = patternEndPosition
        }
      end

    end

  end

  return closestPattern, closestPatternPosition

end

---
-- Returns whether the current found pattern matched a function definition.
--
-- @tparam string _fileContents The file contents
-- @tparam string _pattern The pattern
-- @tparam string _startPosition The start position of the pattern
--
-- @treturn bool True if the pattern matched a function definition, false otherwise
--
function DocumentableContentsExtractor:isNextIdentifierFunction(_fileContents, _pattern, _startPosition)

  local functionPattern = _pattern .. "%[ *\n"
  return (_fileContents:find(functionPattern, _startPosition) == _startPosition)

end

---
-- Extracts a function from the file contents.
--
-- @tparam string _fileContents The file contents to extract the function from
-- @tparam string _pattern The pattern that matched the function
-- @tparam int _startPosition The start position of the pattern in the file contents
-- @tparam int _endPosition The end position of the pattern in the file contents
-- @tparam bool _isDocumentable True if the extracted function is documentable, false otherwise
--
-- @treturn int The extracted function's end position
--
function DocumentableContentsExtractor:extractFunction(_fileContents, _pattern, _startPosition, _endPosition, _isDocumentable)

  local extractedFunction = ExtractedFunction(_pattern, _startPosition, _endPosition)
  local extractedFunctionBodyEndPosition = extractedFunction:extractFromFileContents(_fileContents)

  if (_isDocumentable) then
    self:addFunction(extractedFunction)
  end

  return extractedFunctionBodyEndPosition

end

---
-- Extracts a variable from the file contents.
--
-- @tparam string _fileContents The file contents to extract the variable from
-- @tparam string _pattern The pattern that matched the variable
-- @tparam int _startPosition The start position of the pattern in the file contents
-- @tparam int _endPosition The end position of the pattern in the file contents
-- @tparam bool _isDocumentable True if the extracted function is documentable, false otherwise
--
-- @treturn int The extracted variable's end position
--
function DocumentableContentsExtractor:extractVariable(_fileContents, _pattern, _startPosition, _endPosition, _isDocumentable)
  local extractedVariable = ExtractedVariable(_pattern, _startPosition, _endPosition)
  local extractedVariableBodyEndPosition = extractedVariable:extractFromFileContents(_fileContents)

  if (_isDocumentable) then
    self:addVariable(extractedVariable)
  end

  return extractedVariableBodyEndPosition
end

---
-- Adds a extracted function to this DocumentableContentsExtractor.
--
-- @tparam ExtractedFunction _extractedFunction The extracted function to add
--
function DocumentableContentsExtractor:addFunction(_extractedFunction)

  local existingExtractedFunction, existingExtractedFunctionIndex = self:getDocumentableContentByName(
    self.extractedFunctions, _extractedFunction:getName()
  )

  if (existingExtractedFunction) then

    -- If the existing function has an empty body, it is probably the defintion for an event handler
    -- and thus may not be overwritten by usages of that event handler
    local isEventHandlerDefinition = (existingExtractedFunction:getBody() == "")

    if (not isEventHandlerDefinition) then
      self.extractedFunctions[existingExtractedFunctionIndex] = _extractedFunction
    end

  else
    table.insert(self.extractedFunctions, _extractedFunction)
  end

end

---
-- Adds a extracted variable to this DocumentableContentsExtractor.
--
-- @tparam ExtractedVariable _extractedVariable The extracted variable to add
--
function DocumentableContentsExtractor:addVariable(_extractedVariable)

  local existingExtractedVariable, existingExtractedVariableIndex = self:getDocumentableContentByName(
    self.extractedVariables, _extractedVariable:getName()
  )

  if (existingExtractedVariable) then
    -- Always replace the old definition of the variable
    self.extractedVariables[existingExtractedVariableIndex] = _extractedVariable
  else
    table.insert(self.extractedVariables, _extractedVariable)
  end

end

---
-- Returns a documentable content by its name.
-- Will return nil, nil if the documentable content could not be found in the given list.
--
-- @tparam ExtractedDocumentableContent[] _documentableContents The list of documentable contents to search
-- @tparam string _name The name to search for
--
-- @treturn ExtractedDocumentableContent, int The documentable content and its index in the list
--
function DocumentableContentsExtractor:getDocumentableContentByName(_documentableContents, _name)

  local existingDocumentableContentWithName
  local existingDocumentableContentWithNameIndex
  for i, extractedDocumentableContent in ipairs(_documentableContents) do

    if (extractedDocumentableContent:getName() == _name) then
      existingDocumentableContentWithName = extractedDocumentableContent
      existingDocumentableContentWithNameIndex = i
      break
    end

  end

  return existingDocumentableContentWithName, existingDocumentableContentWithNameIndex

end


return DocumentableContentsExtractor
