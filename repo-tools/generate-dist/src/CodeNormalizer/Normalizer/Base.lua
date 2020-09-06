---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Base class for Normalizer's.
-- Normalizer's normalize a single property for given sets of lines, e.g. removing comments or whitespace.
--
-- @type BaseNormalizer
--
local BaseNormalizer = Object:extend()


-- Public Methods

---
-- Normalizes a given set of lines.
--
-- @tparam string[] _lines The lines to normalize
--
-- @treturn string[] The normalized lines
--
function BaseNormalizer:normalize(_lines)
end


return BaseNormalizer
