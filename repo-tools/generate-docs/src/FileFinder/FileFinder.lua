---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local lfs = require "lfs"
local Object = require "classic"
local File = require "src.FileFinder.File"

---
-- Provides methods to find all files in a directory.
--
-- @type FileFinder
--
local FileFinder = Object:extend()


-- Public Methods

---
-- Returns all files in a specified directory recursively.
--
-- @tparam string _path The path to the directory
--
-- @treturn File[] The files in the directory
--
function FileFinder:getFilesInPath(_path)

  local files = {}
  for i, filePath in ipairs(self:getFilePathsRecursive(_path)) do
    files[i] = File(filePath)
  end

  return files

end


-- Private Methods

---
-- Return the paths of all files inside a directory.
--
-- @tparam string _targetDirectoryPath The path to the directory to search for files in
--
-- @treturn string[] The list of file paths
--
function FileFinder:getFilePathsRecursive(_targetDirectoryPath)

  local filePaths = {}

  for fileName in lfs.dir(_targetDirectoryPath) do
    if (fileName ~= "." and fileName ~= "..") then

      local absoluteFilePath = _targetDirectoryPath .. "/" .. fileName
      local attributes = lfs.attributes(absoluteFilePath)

      if (attributes.mode == "directory") then
        local subDirectoryFilePaths = self:getFilePathsRecursive(absoluteFilePath)
        for _, subDirectoryFilePath in ipairs(subDirectoryFilePaths) do
          table.insert(filePaths, subDirectoryFilePath)
        end

      elseif (fileName:match("%.cfg$")) then
        -- The path target is a file
        table.insert(filePaths, absoluteFilePath)
      end

    end
  end

  return filePaths

end


return FileFinder
