---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local DocBlockParser = require "src.Parser.DocBlockParser"
local Variable = require "src.Parser.ParsedContents.Variable"

---
-- Parses information from an extracted variable.
--
-- @type VariableParser
--
local VariableParser = Object:extend()


-- Public Methods

---
-- Parses a ExtractedVariable and returns a parsed Variable.
--
-- @tparam ExtractedVariable _extractedVariable The extracted variable to parse
--
-- @treturn Variable The parsed variable infos
--
function VariableParser:parse(_extractedVariable)

  local docBlockParser = DocBlockParser(_extractedVariable:getDocBlock())
  local shortDescription, detailedDescription = self:getDescriptions(docBlockParser)

  return Variable(_extractedVariable:getName(), shortDescription, detailedDescription)

end


-- Private Methods

---
-- Returns the short and detailed descriptions from a variable's doc block.
--
-- @tparam DocBlockParser _docBlockParser The doc block parser for the variable's doc block
--
-- @treturn string, string The short and detailed descriptions
--
function VariableParser:getDescriptions(_docBlockParser)

  local linesWithoutTags = _docBlockParser:getLinesWithoutTags()

  local firstSentence = ""
  local lineNumber, firstSentenceEnd
  for i, line in ipairs(linesWithoutTags) do

    firstSentenceEnd = line:find("%.")
    if (firstSentenceEnd) then
      lineNumber = i
      break
    else

      if (#firstSentence > 0 and #line > 0) then
        firstSentence = firstSentence .. " "
      end

      firstSentence = firstSentence .. line
    end

  end

  local detailedDescriptionLines = {}
  if (firstSentenceEnd) then

    if (#firstSentence > 0) then
      firstSentence = firstSentence .. " "
    end
    firstSentence = firstSentence .. linesWithoutTags[lineNumber]:sub(1, firstSentenceEnd - 1)

    local remainingLineStart = linesWithoutTags[lineNumber]:find("[^ ]", firstSentenceEnd + 1)
    if (remainingLineStart) then
      local remainingLine = linesWithoutTags[lineNumber]:sub(remainingLineStart)
      table.insert(detailedDescriptionLines, remainingLine)
    end

    for i = lineNumber + 1, #linesWithoutTags, 1 do
      if (not linesWithoutTags[i]:match("^ *$")) then
        table.insert(detailedDescriptionLines, linesWithoutTags[i])
      end
    end

  end


  return firstSentence, detailedDescriptionLines

end


return VariableParser
