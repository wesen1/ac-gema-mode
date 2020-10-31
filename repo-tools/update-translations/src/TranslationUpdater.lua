---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local ClearStringsCodeGenerator = require "src.ClearStringsCodeGenerator"
local StringsCodeGenerator = require "src.StringsCodeGenerator"
local StringsFileParser = require "src.StringsFileParser"
local Object = require "classic"
local path = require "pl.path"

---
-- Updates the clear-strings.cfg and the strings_*.cfg files from the contents of the strings_en.cfg file.
--
-- @type TranslationUpdater
--
local TranslationUpdater = Object:extend()


---
-- The ClearStringsCodeGenerator that will be used to generate the content of the clear-strings.cfg file
--
-- @tfield ClearStringsCodeGenerator clearStringsCodeGenerator
--
TranslationUpdater.clearStringsCodeGenerator = nil

---
-- The StringsCodeGenerator that will be used to generate the contents of the strings_*.cfg files
--
-- @tfield StringsCodeGenerator stringsCodeGenerator
--
TranslationUpdater.stringsCodeGenerator = nil

---
-- The path to the ac-gema-mode/strings directory
--
-- @tfield string stringsDirectoryPath
--
TranslationUpdater.stringsDirectoryPath = nil

---
-- The parsed strings_en.cfg file
--
-- @tfield StringsFileParser parsedStringsBaseFile
--
TranslationUpdater.parsedStringsBaseFile = nil


---
-- TranslationUpdater constructor.
--
function TranslationUpdater:new()
  self.clearStringsCodeGenerator = ClearStringsCodeGenerator()
  self.stringsCodeGenerator = StringsCodeGenerator()
end


-- Public Methods

---
-- Initializes the TranslationUpdater.
--
-- @tparam string _stringsDirectoryPath The path to the ac-gema-mode/strings directory
--
function TranslationUpdater:initialize(_stringsDirectoryPath)

  self.stringsDirectoryPath = _stringsDirectoryPath

  -- Parse the base string file
  local stringsBaseFilePath = self.stringsDirectoryPath .. "/strings_en.cfg"
  self.parsedStringsBaseFile = StringsFileParser()
  self.parsedStringsBaseFile:parse(stringsBaseFilePath)

end

---
-- Generates the clear-strings.cfg file from the current parsed strings base file.
--
function TranslationUpdater:updateClearStringsFile()

  local clearStringsFilePath = self.stringsDirectoryPath .. "/clear-strings.cfg"
  local clearStringsFile = io.open(clearStringsFilePath, "w")
  clearStringsFile:write(self.clearStringsCodeGenerator:generateClearStringsCode(self.parsedStringsBaseFile))
  clearStringsFile:close()

end

---
-- Generates all strings_*.cfg files from the current parsed strings base file.
--
-- @tparam string[] _languages The languages to generate strings_*.cfg files for
--
function TranslationUpdater:updateTranslationFiles(_languages)

  local stringTranslationFilePath, parsedExistingTranslationsFile
  for _, languageIdentifier in ipairs(_languages) do

    stringTranslationFilePath = self.stringsDirectoryPath .. "/strings_" .. languageIdentifier .. ".cfg"

    if (path.exists(stringTranslationFilePath)) then
      parsedExistingTranslationsFile = StringsFileParser()
      parsedExistingTranslationsFile:parse(stringTranslationFilePath)
    else
      parsedExistingTranslationsFile = nil
    end

    local stringTranslationFile = io.open(stringTranslationFilePath, "w")
    stringTranslationFile:write(
      self.stringsCodeGenerator:generateStringsCode(self.parsedStringsBaseFile, parsedExistingTranslationsFile)
    )
    stringTranslationFile:close()

  end

end


return TranslationUpdater
