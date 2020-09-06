---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local CodeNormalizer = require "src.CodeNormalizer.CodeNormalizer"
local FileFinder = require "src.FileFinder.FileFinder"
local IncludeFileResolver = require "src.IncludeFileResolver.IncludeFileResolver"
local Object = require "classic"
local tablex = require "pl.tablex"

---
-- Generates a single line from a given entry point CubeScript file.
-- This also takes care of resolving included files and merging them into the resulting line.
--
-- @type DistGenerator
--
local DistGenerator = Object:extend()


---
-- The CodeNormalizer that will be used to normalize all loaded code lines
--
-- @tfield CodeNormalizer codeNormalizer
--
DistGenerator.codeNormalizer = nil

---
-- The FileFinder that will be used to find the entry point CubeScript file and its included files
--
-- @tfield FileFinder fileFinder
--
DistGenerator.fileFinder = nil

---
-- The IncludeFileResolver that will be used to translate include commands to sets of included files
--
-- @tfield IncludeFileResolver includeFileResolver
--
DistGenerator.includeFileResolver = nil


---
-- DistGenerator constructor.
--
-- @tparam string _scriptsDirectoryPath The path to the AssaultCube "scripts" directory from which to read source files
--
function DistGenerator:new(_scriptsDirectoryPath)

  self.codeNormalizer = CodeNormalizer()
  self.fileFinder = FileFinder(_scriptsDirectoryPath)
  self.includeFileResolver = IncludeFileResolver(self.fileFinder)

end


-- Public Methods

---
-- Generates a single line from a given cubescript file.
-- The path to the cubescript file must be relative from the AssaultCube "scripts" directory.
--
-- @tparam string _relativeScriptPath The path to a cubescript file to generate a single line from
--
-- @treturn string The generated single line representation of the code contained in the cubescript file
--
function DistGenerator:generateDistFor(_relativeScriptPath)

  local file = self.fileFinder:getFile(_relativeScriptPath)
  local lines = self:parseFile(file)

  return table.concat(lines, "")

end


-- Private Methods

---
-- Parses the contents of a single file.
-- Will be called recursively if include commands are encountered.
--
-- @tparam File _file The file to parse
--
-- @treturn string[] The parsed lines of the file (including the lines from include files)
--
function DistGenerator:parseFile(_file)

  local lines = _file:getContents()
  local normalizedLines = self.codeNormalizer:normalize(lines)

  local includedFiles
  local parsedLines = {}
  for _, line in ipairs(normalizedLines) do

    includedFiles = self.includeFileResolver:getFilesIncludedByLine(line)
    if (#includedFiles == 0) then
      table.insert(parsedLines, line)
    else
      for _, includedFile in ipairs(includedFiles) do
        tablex.insertvalues(parsedLines, self:parseFile(includedFile))
      end
    end

  end

  return parsedLines

end


return DistGenerator
