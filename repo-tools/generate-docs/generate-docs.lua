---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local argparse = require "argparse"
local path = require "path"
local Documentator = require "src.Documentator"

---
-- Parses the configuration that was passed via the script arguments.
--
local function getConfiguration()

  -- Parse the input arguments
  local parser = argparse("generate-docs", "A documentation generator for AssaultCube CubeScripts")
  parser:option("-s --sourceDirectoryPath", "The path to the source directory", ".")
  parser:option("-n --namespace", "The namespace for the documentation", "")
  parser:option("-o --outputFilePath", "The file to save the generated documentation to", "./docs.cfg")

  local arguments = parser:parse()

  if (arguments["namespace"] == "") then
    -- No namepace was specified, use the source directory folders name as namespace

    -- Fetch the absolute path to the source directory
    local sourceDirectoryPath = arguments["sourceDirectoryPath"]
    local absoluteSourceDirectoryPath
    if (sourceDirectoryPath:sub(1, 1) == "/") then
      absoluteSourceDirectoryPath = sourceDirectoryPath
    else
      absoluteSourceDirectoryPath = path.normalize(path.currentdir() .. "/" .. sourceDirectoryPath)
    end

    arguments["namespace"] = absoluteSourceDirectoryPath:match("/([^/]+)$")

  end


  return arguments

end


-- Script

-- Print a title
print("\nAC-CubeScript documentation generator v0.1\n")

-- Fetch the configuration
local configuration = getConfiguration()
local sourceDirectoryPath = configuration["sourceDirectoryPath"]
local namespace = configuration["namespace"]
local outputFilePath = configuration["outputFilePath"]

-- Print the configuration
print("Configuration:")
print("  source directory: " .. sourceDirectoryPath)
print("  documentation namespace: " .. namespace)
print("  output file: " .. outputFilePath .. "\n\n");


-- Generate the documentation code from all source files
io.write("Generating documentation from source files in \"" .. sourceDirectoryPath .. "\" ...")
local documentator = Documentator()
local documentationCode = documentator:generateDocumentation(sourceDirectoryPath, namespace)
io.write(" OK\n")

-- Write the documentation code to the specified output file
io.write("Writing documentation to \"" .. outputFilePath .. "\" ...")
local outputFile = io.open(outputFilePath, "w")
outputFile:write(documentationCode)
outputFile:close()
io.write(" OK\n\n")
