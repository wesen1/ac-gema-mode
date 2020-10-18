---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseNormalizer = require "src.CodeNormalizer.Normalizer.Base"
local CommentRemover = require "src.CodeNormalizer.Normalizer.CommentRemover"
local EmptyLinesRemover = require "src.CodeNormalizer.Normalizer.EmptyLinesRemover"
local MultiCommandLineSplitter = require "src.CodeNormalizer.Normalizer.MultiCommandLineSplitter"
local Object = require "classic"
local SurroundingWhitespaceRemover = require "src.CodeNormalizer.Normalizer.SurroundingWhitespaceRemover"
local TrailingSemicolonAdder = require "src.CodeNormalizer.Normalizer.TrailingSemicolonAdder"

---
-- Normalizes given sets of cubescript lines.
--
-- @type CodeNormalizer
--
local CodeNormalizer = Object:extend()


---
-- The list of normalizers that will be used to normalize lines
--
-- @tfield Normalizer.Base[] normalizers
--
CodeNormalizer.normalizers = nil


---
-- CodeNormalizer constructor.
--
function CodeNormalizer:new()
  self.normalizers = {
    CommentRemover(),
    MultiCommandLineSplitter(),
    SurroundingWhitespaceRemover(),
    EmptyLinesRemover(),
    TrailingSemicolonAdder()
  }
end


-- Public Methods

---
-- Adds a normalizer to this CodeNormalizer.
--
-- @tparam Normalizer.Base _normalizer The normalizer to add
-- @tparam int _position The position inside the list of normalizers to add the new normalizer to
--
function CodeNormalizer:addNormalizer(_normalizer, _position)
  if (_normalizer.is and type(_normalizer.is) == "function" and _normalizer:is(BaseNormalizer)) then
    table.insert(self.normalizers, _position, _normalizer)
  end
end

---
-- Normalizes a given set of lines.
--
-- @tparam string[] _lines The lines to normalize
--
-- @treturn string[] The normalized lines
--
function CodeNormalizer:normalize(_lines)

  local normalizedLines = _lines
  for _, normalizer in ipairs(self.normalizers) do
    normalizedLines = normalizer:normalize(normalizedLines)
  end

  return normalizedLines

end


return CodeNormalizer
