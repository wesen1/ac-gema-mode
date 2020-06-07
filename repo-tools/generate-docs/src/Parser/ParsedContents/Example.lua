---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Contains information about a parsed function usage example.
--
-- @type Example
--
local Example = Object:extend()


---
-- The example code
--
-- @tfield string code
--
Example.code = nil

---
-- The explanation for the example code
--
-- @tfield string explanation
--
Example.explanation = nil


---
-- Example constructor.
--
-- @tparam string _code The example code
-- @tparam string _explanation The explanation for the example code
--
function Example:new(_code, _explanation)
  self.code = _code
  self.explanation = _explanation
end


-- Getters and Setters

---
-- Returns the example code.
--
-- @treturn string The example code
--
function Example:getCode()
  return self.code
end

---
-- Returns the explanation for the example code.
--
-- @treturn string The explanation for the example code
--
function Example:getExplanation()
  return self.explanation
end


return Example
