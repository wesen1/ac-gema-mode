---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

package.path = package.path .. ";../../?.lua"

local luaunit = require "luaunit"
local DistGenerator = require "src.DistGenerator"


---
-- Checks that the dist code for the example-project is generated as expected.
--
function testCanGenerateDistForExampleProject()

  local distGenerator = DistGenerator("example-project")
  local generatedDistCode = distGenerator:generateDistFor("example.cfg")

  local expectedDistCodeFile = io.open("./expected_output.cfg", "rb")
  local expectedDistCode = expectedDistCodeFile:read("*all")
  expectedDistCodeFile:close()

  luaunit.assertEquals(generatedDistCode, expectedDistCode)

end


-- Run the tests
os.exit(luaunit.LuaUnit:run())
