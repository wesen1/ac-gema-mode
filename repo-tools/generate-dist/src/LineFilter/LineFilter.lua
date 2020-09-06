---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Filters out unneeded lines from given sets of lines.
--
-- @type LineFilter
--
local LineFilter = Object:extend()


---
-- The Filter's that will be used to filter given sets of lines
--
-- @tfield Filter.Base[] filters
--
LineFilter.filters = nil


---
-- LineFilter constructor.
--
function LineFilter:new()
  self.filters = {}
end


-- Public Methods

---
-- Adds a Filter to this LineFilter.
--
-- @tparam Base.Filter _filter The Filter to add
--
function LineFilter:addFilter(_filter)
  table.insert(self.filters, _filter)
end

---
-- Filters a given set of lines.
--
-- @tparam string[] _lines The lines to filter
--
-- @treturn string[] The filtered lines
--
function LineFilter:filterLines(_lines)

  local filteredLines = _lines
  for _, filter in ipairs(self.filters) do
    filteredLines = filter:filterLines(filteredLines)
  end

  return filteredLines

end


return LineFilter
