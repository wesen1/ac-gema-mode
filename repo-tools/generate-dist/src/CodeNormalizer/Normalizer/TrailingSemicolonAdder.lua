---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseNormalizer = require "src.CodeNormalizer.Normalizer.Base"

---
-- Normalizer that adds semicolons to lines that do not end with a semicolon.
--
-- @type TrailingSemicolonAdder
--
local TrailingSemicolonAdder = BaseNormalizer:extend()


-- Public Methods

---
-- Adds semicolons to lines that do not end with a semicolon.
--
-- @tparam string[] _lines The lines to normalize
--
-- @treturn string[] The normalized lines with trailing semicolons
--
function TrailingSemicolonAdder:normalize(_lines)

  local numberOfLines = #_lines

  local trailingSemicolonRequired, nextLine
  local normalizedLines = {}
  for i, line in ipairs(_lines) do

    nextLine = (i < numberOfLines) and _lines[i + 1] or ""

    trailingSemicolonRequired = true
    if (line:match("%[$")) then
      -- The current line is an opening bracket, a semicolon after that would break the code
      trailingSemicolonRequired = false

    elseif (nextLine:match("^%]$")) then
      -- The next line is a closing bracket, a semicolon before that is allowed but not needed
      trailingSemicolonRequired = false
    end

    if (trailingSemicolonRequired and not line:match(";$")) then
      -- The line is missing a required trailing semicolon
      table.insert(normalizedLines, line .. ";")
    else
      table.insert(normalizedLines, line)
    end

  end

  return normalizedLines

end


return TrailingSemicolonAdder
