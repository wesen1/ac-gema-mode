---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local FunctionDocumentationGenerator = require "src.DocumentationGenerator.FunctionDocumentationGenerator"
local VariableDocumentationGenerator = require "src.DocumentationGenerator.VariableDocumentationGenerator"

---
-- Provides methods to generate the documentation for the entire source code
--
-- @type DocumentationGenerator
--
local DocumentationGenerator = Object:extend()


---
-- DocumentationGenerator constructor.
--
function DocumentationGenerator:new()
  self.functionDocumentationGenerator = FunctionDocumentationGenerator()
  self.variableDocumentationGenerator = VariableDocumentationGenerator()
end


-- Public Methods

---
-- Generates the documentation for the entire source code.
--
-- @tparam string _namespace The namespace for the documentation
-- @tparam Variable[] _variables The variables
--
-- @treturn string The documentation for the entire source code
--
function DocumentationGenerator:generateDocumentation(_namespace, _variables, _functions)

  local documentationCommands = {
    "docsection [" .. _namespace .. "];"
  }

  -- Generate variable documentations
  local variableDocumentation
  for _, variable in ipairs(_variables) do
    variableDocumentation = self.variableDocumentationGenerator:generateDocumentation(variable)
    table.insert(documentationCommands, variableDocumentation)
  end

  -- Generate function documentations
  local functionDocumentation
  for _, documentableFunction in ipairs(_functions) do
    functionDocumentation = self.functionDocumentationGenerator:generateDocumentation(documentableFunction)
    table.insert(documentationCommands, functionDocumentation)
  end

  return table.concat(documentationCommands, "\n\n") .. "\n"

end


return DocumentationGenerator
