---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Exec = require "src.IncludeFileResolver.IncludeCommandParser.Exec"
local Execdir = require "src.IncludeFileResolver.IncludeCommandParser.Execdir"
local Object = require "classic"

---
-- Resolves any file including commands in code lines and returns lists of File's that are included by a line.
--
-- @type IncludeFileResolver
--
local IncludeFileResolver = Object:extend()


---
-- The list of IncludeCommandParser's that will be used to detect and replace include commands
--
-- @tfield IncludeCommandParser.Base[] includeCommandParsers
--
IncludeFileResolver.includeCommandParsers = nil


---
-- IncludeFileResolver constructor.
--
-- @tparam FileFinder _fileFinder The FileFinder to use for finding included files
--
function IncludeFileResolver:new(_fileFinder)
  self.includeCommandParsers = {
    Exec(_fileFinder),
    Execdir(_fileFinder)
  }
end


-- Public Methods

---
-- Returns all File's that are included by a given line.
-- Will return an empty list if no File's are included by the line.
--
-- @tparam string _line The line to check
--
-- @treturn File[] The File's that are included by the line
--
function IncludeFileResolver:getFilesIncludedByLine(_line)

  for _, includeCommandParser in ipairs(self.includeCommandParsers) do
    if (includeCommandParser:lineContainsIncludeCommand(_line)) then
      return includeCommandParser:getFilesIncludedByIncludeCommand(_line)
    end
  end

  return {}

end


return IncludeFileResolver
