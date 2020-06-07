---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"
local DocumentationGenerator = require "src.DocumentationGenerator.DocumentationGenerator"
local DocumentableContentsExtractor = require "src.Extractor.DocumentableContentsExtractor"
local FileFinder = require "src.FileFinder.FileFinder"
local FunctionParser = require "src.Parser.FunctionParser"
local VariableParser = require "src.Parser.VariableParser"

---
-- Provides methods to generate the documentation for all files inside a directory.
--
-- @type Documentator
--
local Documentator = Object:extend()


---
-- The file finder
--
-- @tfield FileFinder fileFinder
--
Documentator.fileFinder = nil

---
-- The variable parser
--
-- @tfield VariableParser variableParser
--
Documentator.variableParser = nil

---
-- The function parser
--
-- @tfield FunctionParser functionParser
--
Documentator.functionParser = nil


---
-- Documentator constructor.
--
function Documentator:new()
  self.fileFinder = FileFinder()
  self.variableParser = VariableParser()
  self.functionParser = FunctionParser()
  self.documentationGenerator = DocumentationGenerator()
end


-- Public Methods

---
-- Returns the documentation for all files in a specified directory.
--
-- @tparam string _sourceDirectoryPath The path to the source code directory
-- @tparam string _namespace The namespace for the generated documentation
--
-- @treturn string The documentation for the source code
--
function Documentator:generateDocumentation(_sourceDirectoryPath, _namespace)

  -- Extract all variables and functions from all files in the source directory
  local documentableContentExtractor = DocumentableContentsExtractor()
  for _, file in ipairs(self.fileFinder:getFilesInPath(_sourceDirectoryPath)) do
    documentableContentExtractor:extractDocumentableContentsFromFile(file)
  end

  -- Parse the extracted variables
  local variables = {}
  for _, extractedVariable in ipairs(documentableContentExtractor:getExtractedVariables()) do
    table.insert(variables, self.variableParser:parse(extractedVariable))
  end

  -- Parse the extracted functions
  local functions = {}
  for _, extractedFunction in ipairs(documentableContentExtractor:getExtractedFunctions()) do
    table.insert(functions, self.functionParser:parse(extractedFunction))
  end

  return self.documentationGenerator:generateDocumentation(_namespace, variables, functions)

end


return Documentator
