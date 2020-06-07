---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Parses information about functions and variables from doc blocks.
--
-- @type DocBlockParser
--
local DocBlockParser = Object:extend()


---
-- The doc block lines that are parsed by this DocBlockParser
--
-- @tfield string[] docBlockLines
--
DocBlockParser.docBlockLines = nil


---
-- DocBlockParser constructor.
--
-- @treturn string _docBlock The doc block to parse
--
function DocBlockParser:new(_docBlock)
  self.docBlockLines = self:splitDocBlockIntoNormalizedLines(_docBlock)
end


-- Public Methods

---
-- Returns all doc block lines that contain no tags (@*).
--
-- @treturn string[] The doc block lines that contain no tags
--
function DocBlockParser:getLinesWithoutTags()

  local linesWithoutTags = {}
  for _, line in ipairs(self.docBlockLines) do

    if (not line:match("^@")) then
      table.insert(linesWithoutTags, line)
    end

  end

  return linesWithoutTags

end

---
-- Returns all doc block lines that contain a specified tag.
--
-- @tparam string _tagName The name of the tag (without leading @)
--
-- @treturn string[] The doc block lines that contain the tag
--
function DocBlockParser:getLinesContainingTag(_tagName)

  local linesWithSpecifiedTag = {}
  for _, line in ipairs(self.docBlockLines) do

    if (line:match("^@" .. _tagName)) then
      table.insert(linesWithSpecifiedTag, line)
    end

  end

  return linesWithSpecifiedTag

end


-- Private Methods

---
-- Splits a doc block into normalized lines.
--
-- @tparam string _docBlock The doc block to split into lines
--
-- @treturn string[] The normalized doc block lines
--
function DocBlockParser:splitDocBlockIntoNormalizedLines(_docBlock)

  local docBlockLines = {}
  for line in _docBlock:gmatch("[^\n]+") do

    -- Remove leading "//"'s' and trim leading and trailing whitespace
    local normalizedLine = line:match("^ *// *(.*) *$")
    table.insert(docBlockLines, normalizedLine)
  end

  return docBlockLines

end


return DocBlockParser
