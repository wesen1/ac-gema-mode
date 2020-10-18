---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseNormalizer = require "src.CodeNormalizer.Normalizer.Base"

---
-- Normalizer that removes trailing comments from given sets of lines.
--
-- @type CommentRemover
--
local CommentRemover = BaseNormalizer:extend()


-- Public Methods

---
-- Removes trailing comments from a given set of lines.
--
-- @tparam string[] _lines The lines to remove trailing comments from
--
-- @treturn string[] The lines with removed trailing comments
--
function CommentRemover:normalize(_lines)

  local normalizedLine
  local normalizedLines = {}
  for _, line in ipairs(_lines) do

    if (line:match("^docremark")) then
      -- TODO: Fix for now to prevent URLs (e.g. http://example.com) from being interpreted as comments
      -- In this codebase docremark is never used manually, so there will never be trailing comments after
      -- these commands
      table.insert(normalizedLines, line)
    else
      normalizedLine = line:gsub("//.*$", "")
      table.insert(normalizedLines, normalizedLine)
    end

  end

  return normalizedLines

end


return CommentRemover
