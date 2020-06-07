---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Contains information about a parsed function argument.
--
-- @type Argument
--
local Argument = Object:extend()


---
-- The Argument's name
--
-- @tfield string name
--
Argument.name = nil

---
-- The Argument's description
--
-- @tfield string description
--
Argument.description = nil

---
-- The Argument's notes
--
-- @tfield string notes
--
Argument.notes = nil

---
-- True if the Argument's values have a variable length, false otherwise
--
-- @tfield bool hasVariableLength
--
Argument.hasVariableLength = nil


---
-- Argument constructor.
--
-- @tparam string _name The Argument's name
-- @tparam string _description The Argument's description
-- @tparam string _notes The Argument's notes
-- @tparam bool _hasVariableLength True if the Argument's values have a variable length, false otherwise
--
function Argument:new(_name, _description, _notes, _hasVariableLength)
  self.name = _name
  self.description = _description
  self.notes = _notes
  self.hasVariableLength = _hasVariableLength
end


-- Getters and Setters

---
-- Returns the Argument's name.
--
-- @treturn string The Argument's name
--
function Argument:getName()
  return self.name
end

---
-- Returns the Argument's description.
--
-- @treturn string The Argument's description
--
function Argument:getDescription()
  return self.description
end

---
-- Returns the Argument's notes.
--
-- @treturn string The Argument's notes
--
function Argument:getNotes()
  return self.notes
end

---
-- Returns whether the Argument's values have a variable length.
--
-- @treturn bool True if the Argument's values have a variable length, false otherwise
--
function Argument:getHasVariableLength()
  return self.hasVariableLength
end


return Argument
