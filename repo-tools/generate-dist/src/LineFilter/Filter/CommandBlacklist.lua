---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local BaseFilter = require "src.LineFilter.Filter.Base"

---
-- Filter that filters out lines if they contain a CubeScript command of a configurable list of blacklisted commands.
--
-- @type CommandBlacklist
--
local CommandBlacklist = BaseFilter:extend()


---
-- The blacklisted CubeScript commands that should be filtered out
--
-- @tfield string[] blacklistedCommands
--
CommandBlacklist.blacklistedCommands = nil


---
-- CommandBlacklist constructor.
--
-- @tparam string[] _blacklistedCommands The blacklisted CubeScript commands to filter out
--
function CommandBlacklist:new(_blacklistedCommands)
  self.blacklistedCommands = _blacklistedCommands
end


-- Public Methods

---
-- Filters out lines from a given set of lines that contain one of the blacklisted CubeScript commands.
--
-- @tparam string[] _lines The lines to filter
--
-- @treturn string[] The filtered lines
--
function CommandBlacklist:filterLines(_lines)

  local lineContainsBlacklistedCommand
  local filteredLines = {}
  for _, line in ipairs(_lines) do

    lineContainsBlacklistedCommand = false
    for _, blacklistedCommand in ipairs(self.blacklistedCommands) do
      if (line:match("^" .. blacklistedCommand .. " ")) then
        lineContainsBlacklistedCommand = true
        break
      end
    end

    if (not lineContainsBlacklistedCommand) then
      table.insert(filteredLines, line)
    end

  end

  return filteredLines

end


return CommandBlacklist
