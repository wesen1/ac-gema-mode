---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Provides methods to read a file.
--
-- @type File
--
local File = Object:extend()


---
-- The file path of the file
--
-- @tfield string path
--
File.path = nil


---
-- File constructor.
--
-- @tparam string _path The file path of the file
--
function File:new(_path)
  self.path = _path
end


-- Public Methods

---
-- Returns the contents of the File.
--
-- @treturn string The File's contents
--
function File:getContents()

  local fileContents = ""
  for line in io.lines(self.path) do
    fileContents = fileContents .. "\n" .. line
  end

  return fileContents

end


return File
