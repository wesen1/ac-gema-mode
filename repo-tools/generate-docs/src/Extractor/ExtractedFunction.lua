---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local ExtractedDocumentableContent = require "src.Extractor.ExtractedDocumentableContent"

---
-- Contains the raw cubescript contents of a function.
--
-- @type ExtractedFunction
--
local ExtractedFunction = ExtractedDocumentableContent:extend()


-- Protected Methods

---
-- Returns the body start and end position of the function from the file contents.
--
-- @tparam string _fileContents The file contents
--
-- @treturn int, int The body start and end position
--
function ExtractedFunction:getBodyPosition(_fileContents)

  local currentStringOffset = self.patternStartPosition
  local nextSquareBracketPosition, nextSquareBracket
  local currentNestingLevel = 1

  repeat

    nextSquareBracketPosition = _fileContents:find("[%[%]]", currentStringOffset)
    if (not nextSquareBracketPosition) then
      break
    end

    nextSquareBracket = _fileContents:sub(nextSquareBracketPosition, nextSquareBracketPosition)

    if (nextSquareBracket == "[") then
      -- Next square bracket is a opening square bracket
      -- This is a opening square bracket inside the function
      currentNestingLevel = currentNestingLevel + 1
    else
      -- Next square bracket is a closing square bracket
      -- This is either a closing square bracket inside the function or the end of the function
      currentNestingLevel = currentNestingLevel - 1
    end

    currentStringOffset = nextSquareBracketPosition + 1

  until (currentNestingLevel == 1)

  return self.patternEndPosition + 2, currentStringOffset

end


return ExtractedFunction
