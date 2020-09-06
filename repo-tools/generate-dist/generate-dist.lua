---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local argparse = require "argparse"
local DistGenerator = require "src.DistGenerator"

---
-- Parses the configuration that was passed via the script arguments.
--
local function getConfiguration()

  -- Parse the input arguments
  local parser = argparse("generate-dist", "A dist generator for AssaultCube CubeScripts")
  parser:option("-s --scriptsDirectoryPath", "The path to the AssaultCube \"scripts\" directory")
  parser:option("-f --entryPointScriptPath", "The relative path to the entry point script in the \"scripts\" directory")
  parser:option("-o --outputFilePath", "The file to save the generated dist code to", "./dist.cfg")
  parser:flag("--ignoreDocs", "Add this flag to ignore all ingame documentation related lines")

  local arguments = parser:parse()

  return arguments

end


-- Script

-- Print a title
print("\nAC-CubeScript dist generator v0.1\n")

-- Fetch the configuration
local configuration = getConfiguration()
local scriptsDirectoryPath = configuration["scriptsDirectoryPath"]
local entryPointScriptPath = configuration["entryPointScriptPath"]
local outputFilePath = configuration["outputFilePath"]
local ignoreDocs = configuration["ignoreDocs"]

-- Print the configuration
print("Configuration:")
print("  scripts directory: " .. scriptsDirectoryPath)
print("  entry point script: " .. entryPointScriptPath)
print("  output file: " .. outputFilePath)
print("  ignoring docs: " .. (ignoreDocs and "yes" or "no") .. "\n\n")


-- Generate the dist code from the given entry point script
io.write("Generating dist from script \"" .. entryPointScriptPath .. "\" ...")
local distGenerator = DistGenerator(scriptsDirectoryPath)
local distCode = distGenerator:generateDistFor(entryPointScriptPath, ignoreDocs)
io.write(" OK\n")

-- Write the dist code to the specified output file
io.write("Writing dist code to \"" .. outputFilePath .. "\" ...")
local outputFile = io.open(outputFilePath, "w")
outputFile:write(distCode)
outputFile:close()
io.write(" OK\n\n")
