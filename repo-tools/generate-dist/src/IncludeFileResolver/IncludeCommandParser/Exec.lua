---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseIncludeCommandParser = require "src.IncludeFileResolver.IncludeCommandParser.Base"

---
-- IncludeCommandParser for the "exec" command.
-- The "exec" command includes single cubescript files.
--
-- @type ExecIncludeCommandParser
--
local ExecIncludeCommandParser = BaseIncludeCommandParser:extend()


---
-- ExecIncludeCommandParser.
--
-- @tparam FileFinder _fileFinder The FileFinder to use to find included File's
--
function ExecIncludeCommandParser:new(_fileFinder)
  BaseIncludeCommandParser.new(self, _fileFinder, "exec +\"scripts/([^\"]+)\";")
end


-- Public Methods

---
-- Parses a line that contains a "exec" command and returns the File's that are included by the command.
--
-- @tparam string _line The line with the include command
--
-- @treturn File[] The list of File's that are included by the command
--
function ExecIncludeCommandParser:getFilesIncludedByIncludeCommand(_line)

  local includeFilePath = _line:match(self.commandPattern)
  local includeFile = self.fileFinder:getFile(includeFilePath)

  return { includeFile }

end


return ExecIncludeCommandParser
