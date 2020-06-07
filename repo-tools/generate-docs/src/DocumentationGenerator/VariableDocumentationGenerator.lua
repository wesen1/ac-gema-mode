---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Provides methods to generate the ingame documentation for Variable's.
--
-- @type VariableDocumentationGenerator
--
local VariableDocumentationGenerator = Object:extend()


---
-- The templates that will be used to generate documentations for the variables
--
-- @tfield string[] templates
--
VariableDocumentationGenerator.templates = {
  ["description"] = "docident [%s][%s];",
  ["detailedDescription"] = "docremark [%s];"
}


-- Public Methods

---
-- Generates and returns the full ingame documentation for a variable.
--
-- @tparam Variable _variable The variable
--
-- @treturn string The full ingame documentation for the variable
--
function VariableDocumentationGenerator:generateDocumentation(_variable)

  -- Generate the basic documentation
  local variableDocumentation = string.format(
    VariableDocumentationGenerator.templates["description"],
    _variable:getName(),
    _variable:getShortDescription()
  )

  -- Add a more detailed description if there is one
  if (_variable:getDetailedDescription()) then

    for _, detailedDescriptionLine in ipairs(_variable:getDetailedDescription()) do

      local detailedDescription = string.format(
        VariableDocumentationGenerator.templates["detailedDescription"], detailedDescriptionLine
      )
      variableDocumentation = variableDocumentation .. "\n" .. detailedDescription

    end
  end

  return variableDocumentation

end


return VariableDocumentationGenerator
