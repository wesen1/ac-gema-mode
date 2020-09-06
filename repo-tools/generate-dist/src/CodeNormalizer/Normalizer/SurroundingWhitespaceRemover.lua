---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseNormalizer = require "src.CodeNormalizer.Normalizer.Base"

---
-- Normalizer that removes leading and trailing whitespace from given sets of lines.
--
-- @type SurroundingWhitespaceRemover
--
local SurroundingWhitespaceRemover = BaseNormalizer:extend()


-- Public Methods

---
-- Removes all leading and trailing whitespace from a given set of lines.
--
-- @tparam string[] _lines The list of lines to remove all leading and trailing whitespace from
--
-- @treturn string[] The list of lines with removed leading and trailing whitespace
--
function SurroundingWhitespaceRemover:normalize(_lines)

  local normalizedLine
  local normalizedLines = {}
  for _, line in ipairs(_lines) do
    normalizedLine = line:gsub("^%s+", ""):gsub("%s+$", "")
    table.insert(normalizedLines, normalizedLine)
  end

  return normalizedLines

end


return SurroundingWhitespaceRemover
