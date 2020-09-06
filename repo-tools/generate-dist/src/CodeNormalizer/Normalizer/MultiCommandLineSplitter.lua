---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseNormalizer = require "src.CodeNormalizer.Normalizer.Base"
local stringx = require "pl.stringx"
local tablex = require "pl.tablex"

---
-- Normalizer that splits lines with multiple commands into separate lines.
--
-- @type MultiCommandLineSplitter
--
local MultiCommandLineSplitter = BaseNormalizer:extend()


-- Public Methods

---
-- Splits lines with multiple commands into separate lines.
--
-- @tparam string[] _lines The lines to normalize
--
-- @treturn string[] The normalized lines with one command per line
--
function MultiCommandLineSplitter:normalize(_lines)

  local normalizedLines = {}
  for _, line in ipairs(_lines) do
    tablex.insertvalues(normalizedLines, stringx.split(line, ";"))
  end

  return normalizedLines

end


return MultiCommandLineSplitter
