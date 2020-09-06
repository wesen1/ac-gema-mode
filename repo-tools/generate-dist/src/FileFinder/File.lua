---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
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
-- Returns the lines in the File.
--
-- @treturn string[] The lines in the File
--
function File:getContents()

  local lines = {}
  for line in io.lines(self.path) do
    table.insert(lines, line)
  end

  return lines

end


return File
