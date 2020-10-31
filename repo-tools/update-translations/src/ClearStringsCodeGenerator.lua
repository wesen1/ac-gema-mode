---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Generates the code for the clear-strings.cfg file.
--
-- @type ClearStringsCodeGenerator
--
local ClearStringsCodeGenerator = Object:extend()


-- Public Methods

---
-- Generates the code for the clear-strings.cfg file.
--
-- @tparam StringsFileParser _parsedStringsBaseFile The parsed base strings.cfg file
--
-- @treturn string The generated code
--
function ClearStringsCodeGenerator:generateClearStringsCode(_parsedStringsBaseFile)

  local outputLines = {
    "//",
    "// Auto generated clear strings file.",
    "//",
    "// Requires:",
    "//   * scripts/ac-gema-mode/unpersist/declarations.cfg",
    "//",
    "",
    "persistidents 0;",
    "",
    "// Public Functions",
    "",
    "//",
    "// Deletes all string constants.",
    "//",
    "function deleteAllStrings ["
  }

  for _, stringAlias in ipairs(_parsedStringsBaseFile:getStringAliasNames()) do
    table.insert(outputLines, "  delalias " .. stringAlias .. ";")
  end

  table.insert(outputLines, "]")
  table.insert(outputLines, "")

  return table.concat(outputLines, "\n")

end


return ClearStringsCodeGenerator
