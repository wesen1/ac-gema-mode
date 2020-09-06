---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseNormalizer = require "src.CodeNormalizer.Normalizer.Base"

---
-- Normalizer that removes empty lines from given sets of lines.
--
-- @type EmptyLinesRemover
--
local EmptyLinesRemover = BaseNormalizer:extend()


-- Public Methods

---
-- Remove empty lines from a given set of lines.
--
-- @tparam string[] _lines The list of lines to remove empty lines from
--
-- @treturn string[] The list of lines with removed empty lines
--
function EmptyLinesRemover:normalize(_lines)

  local normalizedLines = {}
  for _, line in ipairs(_lines) do
    if (line ~= "") then
      table.insert(normalizedLines, line)
    end
  end

  return normalizedLines

end


return EmptyLinesRemover
