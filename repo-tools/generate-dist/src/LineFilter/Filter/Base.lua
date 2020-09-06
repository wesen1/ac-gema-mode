---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Base class for Filter's.
-- Filter's filter out lines from given sets of lines based on a specific property.
--
-- @type BaseFilter
--
local BaseFilter = Object:extend()


---
-- Filters out lines from a given set of lines based on a specific property.
--
-- @tparam string[] _lines The lines to filter
--
-- @treturn string[] The filtered lines
--
function BaseFilter:filterLines(_lines)
end


return BaseFilter
