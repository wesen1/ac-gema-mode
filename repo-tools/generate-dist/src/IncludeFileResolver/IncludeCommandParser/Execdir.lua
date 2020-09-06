---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseIncludeCommandParser = require "src.IncludeFileResolver.IncludeCommandParser.Base"

---
-- IncludeCommandParser for the "execdir" command.
-- The "execdir" command includes all cubescript files that are direct childs of a given directory.
--
-- @type ExecdirIncludeCommandParser
--
local ExecdirIncludeCommandParser = BaseIncludeCommandParser:extend()


---
-- ExecdirIncludeCommandParser.
--
-- @tparam FileFinder _fileFinder The FileFinder to use to find included File's
--
function ExecdirIncludeCommandParser:new(_fileFinder)
  BaseIncludeCommandParser.new(self, _fileFinder, "execdir +\"scripts/([^\"]+)\";")
end


-- Public Methods

---
-- Parses a line that contains a "exec" command and returns the File's that are included by the command.
--
-- @tparam string _line The line with the include command
--
-- @treturn File[] The list of File's that are included by the command
--
function ExecdirIncludeCommandParser:getFilesIncludedByIncludeCommand(_line)

  local includeDirectoryPath = _line:match(self.commandPattern)
  return self.fileFinder:getDirectChildFilesOfDirectory(includeDirectoryPath)

end


return ExecdirIncludeCommandParser
