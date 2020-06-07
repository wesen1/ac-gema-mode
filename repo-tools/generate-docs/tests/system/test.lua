---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

package.path = package.path .. ";../../?.lua"

local luaunit = require "luaunit"
local Documentator = require "src.Documentator"


---
-- Checks that the documentation for the example-project is generated as expected.
--
function testCanGenerateDocumentationForExampleProject()

  local documentator = Documentator()

  local generatedDocumentation = documentator:generateDocumentation("./example-project", "my-example")

  local expectedDocumentationFile = io.open("./expected_output.cfg", "rb")
  local expectedDocumentation = expectedDocumentationFile:read("*all")
  expectedDocumentationFile:close()

  luaunit.assertEquals(generatedDocumentation, expectedDocumentation)

end


-- Run the tests
os.exit(luaunit.LuaUnit:run())
