---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local VariableDocumentationGenerator = require "src.DocumentationGenerator.VariableDocumentationGenerator"

---
-- Generates the documentation for Function's.
--
-- @type FunctionDocumentationGenerator
--
local FunctionDocumentationGenerator = VariableDocumentationGenerator:extend()


---
-- The templates that will be used to generate documentations for the functions
--
-- @tfield string[] templates
--
FunctionDocumentationGenerator.templates = {
  ["argument"] = "docargument [%s][%s]%s%s;",
  ["example"] = "docexample [%s][%s];"
}


-- Public Methods

---
-- Generates and returns the full ingame documentation for a function.
--
-- @tparam Function _function The function
--
-- @treturn string The full ingame documentation for the function
--
function FunctionDocumentationGenerator:generateDocumentation(_function)

  local documentation = VariableDocumentationGenerator.generateDocumentation(self, _function)

  -- Generate argument documentations
  for _, argument in ipairs(_function:getArguments()) do
    documentation = documentation .. "\n" .. self:generateArgumentDocumentation(argument)
  end

  -- Generate example documentations
  for _, example in ipairs(_function:getExamples()) do
    documentation = documentation .. "\n" .. self:generateExampleDocumentation(example)
  end

  return documentation

end


-- Private Methods

---
-- Generates and returns the ingame documentation for an Argument.
--
-- @tparam Argument _argument The argument
--
-- @treturn string The ingame documentation for the argument
--
function FunctionDocumentationGenerator:generateArgumentDocumentation(_argument)

  local notes = (_argument:getNotes() or "")
  local hasVariableLength = ""

  if (notes ~= "" or _argument:getHasVariableLength()) then
    notes = "[" .. notes .. "]"
    if (_argument:getHasVariableLength()) then
      hasVariableLength = " 1"
    end

  end

  return string.format(
    FunctionDocumentationGenerator.templates["argument"],
    _argument:getName(), _argument:getDescription(), notes, hasVariableLength
  )

end

---
-- Generates and returns the ingame documentation for an Example.
--
-- @tparam Example _example The example
--
-- @treturn string The ingame documentation for the example
--
function FunctionDocumentationGenerator:generateExampleDocumentation(_example)
  return string.format(
    FunctionDocumentationGenerator.templates["example"], _example:getCode(), _example:getExplanation()
  )
end


return FunctionDocumentationGenerator
