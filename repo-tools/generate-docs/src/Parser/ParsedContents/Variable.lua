---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Contains information about a parsed variable.
--
-- @type Variable
--
local Variable = Object:extend()


---
-- The Variable's name
--
-- @tfield string name
--
Variable.name = nil

---
-- The Variable's short description
--
-- @tfield string shortDescription
--
Variable.shortDescription = "No description"

---
-- The Variable's detailed description
--
-- @tfield string detailedDescription
--
Variable.detailedDescription = nil


---
-- Variable constructor.
--
-- @tparam string _name The Variable's name
-- @tparam string _shortDescription The Variable's short description
-- @tparam string _detailedDescription The Variable's detailed description
--
function Variable:new(_name, _shortDecscription, _detailedDescription)
  self.name = _name
  self.shortDescription = _shortDecscription
  self.detailedDescription = _detailedDescription
end


-- Getters and Setters

---
-- Returns the Variable's name.
--
-- @treturn string The Variable's name
--
function Variable:getName()
  return self.name
end

---
-- Returns the Variable's short description.
--
-- @treturn string The Variable's short description
--
function Variable:getShortDescription()
  return self.shortDescription
end

---
-- Returns the Variable's detailed description.
--
-- @treturn string The Variable's detailed description
--
function Variable:getDetailedDescription()
  return self.detailedDescription
end


return Variable
