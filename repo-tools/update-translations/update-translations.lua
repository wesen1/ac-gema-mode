---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local argparse = require "argparse"
local TranslationUpdater = require "src.TranslationUpdater"

---
-- Parses the configuration that was passed via the script arguments.
--
local function getConfiguration()

  -- Parse the input arguments
  local parser = argparse("update-translations", "Translation related files updater for ac-gema-mode")
  parser:option("-s --stringsDirectoryPath", "The path to the ac-gema-mode/strings directory")
  parser:option("-l --languages", "The relative path to the entry point script in the \"scripts\" directory")
        :args("?")

  local arguments = parser:parse()

  return arguments

end


-- Script

-- Print a title
print("\nAC-CubeScript translation updater v0.1\n")

-- Fetch the configuration
local configuration = getConfiguration()
local stringsDirectoryPath = configuration["stringsDirectoryPath"]
local languages = configuration["languages"] or {}


-- Print the configuration
print("Configuration:")
print("  strings directory: " .. stringsDirectoryPath)
print("  languages: " .. table.concat(languages, ", ") .. "\n\n")


local translationUpdater = TranslationUpdater()

io.write("Initializating TranslationUpdater ...")
translationUpdater:initialize(stringsDirectoryPath)
io.write(" OK\n")

io.write("Updating clear-strings.cfg ...")
translationUpdater:updateClearStringsFile()
io.write(" OK\n")

io.write("Updating clear-strings.cfg ...")
translationUpdater:updateTranslationFiles(languages)
io.write(" OK\n\n")
