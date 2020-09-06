---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Base class for IncludeCommandParser's.
-- IncludeCommandParser's check if cubescript lines contain a include command and return the File's that
-- are included by the command.
--
-- @type BaseIncludeCommandParser
--
local BaseIncludeCommandParser = Object:extend()


---
-- The FileFinder that will be used to find included File's
--
-- @tfield FileFinder fileFinder
--
BaseIncludeCommandParser.fileFinder = nil

---
-- The lua pattern for the command that is handled by this IncludeCommandParser
--
-- @tfield string commandPattern
--
BaseIncludeCommandParser.commandPattern = nil


---
-- BaseIncludeCommandParser constructor.
--
-- @tparam FileFinder _fileFinder The FileFinder to use to find included File's
-- @tparam string _commandPattern The lua pattern for the command that is handled by this IncludeCommandParser
--
function BaseIncludeCommandParser:new(_fileFinder, _commandPattern)
  self.fileFinder = _fileFinder
  self.commandPattern = _commandPattern
end


-- Public Methods

---
-- Returns whether a given cubescript line contains the include command that is handled by this IncludeCommandParser.
--
-- @tparam string _line The line to check
--
-- @treturn bool True if the line contains the command that is handled by this IncludeCommandParser, false otherwise
--
function BaseIncludeCommandParser:lineContainsIncludeCommand(_line)
  return (_line:match(self.commandPattern) ~= nil)
end

---
-- Parses a line that contains the include command that is handled by this IncludeCommandParser and
-- returns the File's that are included by the command.
-- This may only be called for lines that made lineContainsIncludeCommand() return true.
--
-- @tparam string _line The line with the include command
--
-- @treturn File[] The list of File's that are included by the command
--
function BaseIncludeCommandParser:getFilesIncludedByIncludeCommand(_line)
end


return BaseIncludeCommandParser
