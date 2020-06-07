---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Argument = require "src.Parser.ParsedContents.Argument"
local DocBlockParser = require "src.Parser.DocBlockParser"
local Example = require "src.Parser.ParsedContents.Example"
local Function = require "src.Parser.ParsedContents.Function"
local VariableParser = require "src.Parser.VariableParser"

---
-- Parses information from an extracted function.
--
-- @type FunctionParser
--
local FunctionParser = VariableParser:extend()


-- Public Methods

---
-- Parses a ExtractedFunction and returns a parsed Function.
--
-- @tparam ExtractedFunction _extractedFunction The extracted function to parse
--
-- @treturn Function The parsed function infos
--
function FunctionParser:parse(_extractedFunction)

  local docBlockParser = DocBlockParser(_extractedFunction:getDocBlock())
  local shortDescription, detailedDescription = self:getDescriptions(docBlockParser)

  return Function(
    _extractedFunction:getName(),
    shortDescription,
    detailedDescription,
    self:getFunctionArguments(_extractedFunction, docBlockParser),
    self:getExamples(docBlockParser)
  )

end


-- Private Methods

---
-- Returns the short and detailed descriptions from a function's doc block.
--
-- @tparam DocBlockParser _docBlockParser The doc block parser for the function's doc block
--
-- @treturn string, string The short and detailed descriptions
--
function FunctionParser:getDescriptions(_docBlockParser)

  local shortDescription, detailedDescriptionLines = VariableParser.getDescriptions(self, _docBlockParser)

  local returnValueDescription = self:getReturnValueDescription(_docBlockParser)
  if (returnValueDescription) then
    table.insert(
      detailedDescriptionLines,
      1,
      "Returns " .. returnValueDescription:sub(1, 1):lower() .. returnValueDescription:sub(2)
    )
  end

  return shortDescription, detailedDescriptionLines

end

---
-- Returns the function arguments of a extracted function.
--
-- @tparam ExtractedFunction _extractedFunction The extracted function whose arguments to return
-- @tparam DocBlockParser _docBlockParser The doc block parser for the extracted function's doc block
--
-- @treturn Argument[] The parsed function arguments
--
function FunctionParser:getFunctionArguments(_extractedFunction, _docBlockParser)

  local argumentDescriptions = _docBlockParser:getLinesContainingTag("param")
  local argumentPatterns = {
    "^@param *([^ ]+) *([^ ]+) *%(%$arg%d+%) *(.+) *$",
    "^@param *([^ ]+) *$arg%d+ *%(([^ ]+)%) *(.+) *$",
    "^@param *([^ ]+) *([^ ]+) *(.+) *$"
  }

  local arguments = {}
  for i, argumentDescription in ipairs(argumentDescriptions) do

    local matchingPattern
    for _, argumentPattern in ipairs(argumentPatterns) do
      if (argumentDescription:find(argumentPattern) ~= nil) then
        matchingPattern = argumentPattern
        break
      end
    end

    if (matchingPattern) then
      local dataType, argumentName, description = argumentDescription:match(matchingPattern)
      table.insert(arguments, Argument(argumentName, description, "", false))

    else
      print("Could not parse argument description '" .. argumentDescription .. "'")
      table.insert(arguments, Argument("$arg" .. i, "No description", "", false))
    end

  end


  local numberOfArguments = self:getHighestUsedArgumentNumber(_extractedFunction:getBody())
  for i = #arguments + 1, numberOfArguments, 1 do
    table.insert(arguments, Argument("$arg" .. i, "No description", "", false))
  end

  return arguments

end

---
-- Searches a function body for the highest $arg<x> usage and returns the highest found number.
--
-- @tparam string _functionBody The function body to search for $arg<x>'s
--
-- @treturn int The highest found $arg<x> usage
--
function FunctionParser:getHighestUsedArgumentNumber(_functionBody)

  local highestArgumentNumber = 0
  for argumentNumber in _functionBody:gmatch("%$arg(%d+)") do
    argumentNumber = tonumber(argumentNumber)
    if (not highestArgumentNumber or argumentNumber > highestArgumentNumber) then
      highestArgumentNumber = argumentNumber
    end
  end

  return highestArgumentNumber

end

---
-- Returns the return value description from a function's doc block.
--
-- @tparam DocBlockParser _docBlockParser The doc block parser for the extracted function's doc block
--
-- @treturn string The description of the return value or nil if there is no return value description
--
function FunctionParser:getReturnValueDescription(_docBlockParser)

  local returnValueDescriptions = _docBlockParser:getLinesContainingTag("return")

  if (#returnValueDescriptions > 0) then

    local returnValueDescription = returnValueDescriptions[#returnValueDescriptions]
    local dataType, description = returnValueDescription:match("^@return *([^ ]+) (.+) *$")

    return description

  end

end

---
-- Returns the examples from a function's doc block.
--
-- @tparam DocBlockParser _docBlockParser The doc block parser for the extracted function's doc block
--
-- @treturn Example[] The parsed examples
--
function FunctionParser:getExamples(_docBlockParser)

  local exampleDescriptions = _docBlockParser:getLinesContainingTag("example")

  local examples = {}
  if (exampleDescriptions) then

    for _, exampleDescription in ipairs(exampleDescriptions) do

      local exampleCode, explanation = exampleDescription:match("^@example *`([^`]+)` (.+)")
      table.insert(examples, Example(exampleCode, explanation))

    end

  end

  return examples

end


return FunctionParser
