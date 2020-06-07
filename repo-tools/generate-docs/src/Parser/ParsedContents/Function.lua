---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Variable = require "src.Parser.ParsedContents.Variable"

---
-- Contains information about a parsed function.
--
-- @type Function
--
local Function = Variable:extend()


---
-- The function's arguments
--
-- @tfield Argument[] arguments
--
Function.arguments = nil

---
-- The function's examples
--
-- @tfield Example[] examples
--
Function.examples = nil


---
-- Function constructor.
--
-- @tparam string _name The Function's name
-- @tparam string _shortDecsription The Function's short description
-- @tparam string _detailedDescription The Function's detailed description
-- @tparam Argument[] _arguments The Function's arguments
-- @tparam Example[] _examples The Function's examples
--
function Function:new(_name, _shortDecsription, _detailedDescription, _arguments, _examples)
  Variable.new(self, _name, _shortDecsription, _detailedDescription)

  self.arguments = _arguments
  self.examples = _examples
end


-- Getters and Setters

---
-- Returns the Function's arguments.
--
-- @treturn Argument[] The Function's arguments
--
function Function:getArguments()
  return self.arguments
end

---
-- Returns the Function's examples.
--
-- @treturn Example[] The Function's examples
--
function Function:getExamples()
  return self.examples
end


return Function
