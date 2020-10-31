---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local StringsFileParser = require "src.StringsFileParser"
local tablex = require "pl.tablex"

---
-- Generates the code for one of the strings_*.cfg files.
--
-- @type StringsCodeGenerator
--
local StringsCodeGenerator = Object:extend()


-- Public Methods

---
-- Generates the code for one of the strings_*.cfg files.
--
-- @tparam StringsFileParser _parsedStringsBaseFile The parsed base strings.cfg file
-- @tparam StringsFileParser _parsedStringsTranslationFile The parsed target strings_*.cfg file (optional)
--
-- @treturn string The generated code
--
function StringsCodeGenerator:generateStringsCode(_parsedStringsBaseFile, _parsedStringsTranslationFile)

  local isFirstSection = true
  local outputSection, existingOutputSection, firstAliasName

  local outputLines = {}
  for sectionName, section in _parsedStringsBaseFile:getSections() do

    outputSection = section

    if (sectionName == StringsFileParser.SECTION_TYPE_REMAINING_CODE) then
      if (isFirstSection) then
        isFirstSection = false

        if (_parsedStringsTranslationFile) then
          firstAliasName = _parsedStringsBaseFile:getStringAliasNames()[1]
          if (firstAliasName) then
            existingOutputSection = _parsedStringsTranslationFile:getRemainingCodeSectionBefore(firstAliasName)
            if (existingOutputSection) then
              outputSection = existingOutputSection
            end
          end
        end

      end

    else
      if (isFirstSection) then
        isFirstSection = false
      end

      if (_parsedStringsTranslationFile) then
        existingOutputSection = _parsedStringsTranslationFile:getStringAliasSection(sectionName)
        if (existingOutputSection) then
          outputSection = existingOutputSection
        end
      end

    end

    tablex.insertvalues(outputLines, outputSection)

  end

  return table.concat(outputLines, "\n") .. "\n"

end


return StringsCodeGenerator
