---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseNormalizer = require "src.CodeNormalizer.Normalizer.Base"

---
-- Normalizer that converts multi line arrays to single lines.
--
-- @type ArrayFlattener
--
local ArrayFlattener = BaseNormalizer:extend()


---
-- The names of the arrays that will be converted to single line arrays
--
-- @tfield string[] arrayNames
--
ArrayFlattener.arrayNames = nil


---
-- ArrayFlattener constructor.
--
-- @tparam string[] _arrayNames The names of the arrays that should be converted to single line arrays
--
function ArrayFlattener:new(_arrayNames)
  self.arrayNames = _arrayNames
end


-- Public Methods

---
-- Converts the configured arrays to single line arrays if they are contained in a given set of lines.
--
-- @tparam string[] _lines The list of lines to normalize
--
-- @treturn string[] The list of lines with converted arrays
--
function ArrayFlattener:normalize(_lines)

  if (#_lines <= 1) then
    return _lines
  end

  local currentTargetArrayLines
  local normalizedLines = {}
  for _, line in ipairs(_lines) do

    if (currentTargetArrayLines) then
      table.insert(currentTargetArrayLines, line)
      if (line:match("^]")) then
        table.insert(normalizedLines, table.concat(currentTargetArrayLines, " "))
        currentTargetArrayLines = nil
      end

    else

      for _, arrayName in ipairs(self.arrayNames) do
        if (line:match("^.* +" .. arrayName .. " +%[$") or
            line:match("^.* +" .. arrayName .. " +%(format +%[$")) then
          currentTargetArrayLines = { line }
        end
      end

      if (not currentTargetArrayLines) then
        table.insert(normalizedLines, line)
      end

    end

  end

  return normalizedLines

end


return ArrayFlattener
