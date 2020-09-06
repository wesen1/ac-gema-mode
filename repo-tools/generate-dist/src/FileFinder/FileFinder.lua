---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local dir = require "pl.dir"
local File = require "src.FileFinder.File"
local Object = require "classic"
local path = require "pl.path"

---
-- Provides methods to search for File's inside the AssaultCube "scripts" directory.
--
-- @type FileFinder
--
local FileFinder = Object:extend()


---
-- The path to the AssaultCube "scripts" directory
--
-- @tfield string scriptsDirectoryPath
--
FileFinder.scriptsDirectoryPath = nil


---
-- FileFinder constructor.
--
-- @tparam string _scriptsDirectoryPath The path to the AssaultCube "scripts" directory
--
function FileFinder:new(_scriptsDirectoryPath)
  self.scriptsDirectoryPath = _scriptsDirectoryPath
end


-- Public Methods

---
-- Returns a single File from the AssaultCube "scripts" directory.
--
-- @tparam string _filePath The path to the script file relative from the "scripts" directory
--
-- @treturn File The File at the given file path
--
-- @raise error The error when the given file could not be found
--
function FileFinder:getFile(_filePath)

  local absoluteFilePath = self.scriptsDirectoryPath .. "/" .. _filePath
  if (path.isfile(absoluteFilePath)) then
    return File(absoluteFilePath)
  else
    error("Could not find file \"" .. absoluteFilePath .. "\"")
  end

end

---
-- Returns all File's that are direct childs of a given sub directory of the AssaultCube "scripts" directory.
--
-- @tparam string _directoryPath The path to the directory relative from the "scripts" directory
--
-- @ŧreturn File[] The File's inside the directory
--
-- @raise error The error when the given directory could not be found
--
function FileFinder:getDirectChildFilesOfDirectory(_directoryPath)

  local absoluteDirectoryPath = self.scriptsDirectoryPath .. "/" .. _directoryPath
  if (path.isdir(absoluteDirectoryPath)) then

    local files = {}
    for _, filePath in ipairs(dir.getfiles(absoluteDirectoryPath, "*.cfg")) do
      table.insert(files, File(filePath))
    end

    return files

  else
    error("Could not find directory \"" .. absoluteDirectoryPath .. "\"")
  end

end


return FileFinder
