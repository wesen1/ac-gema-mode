---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local ExtractedDocumentableContent = require("src/Extractor/ExtractedDocumentableContent")

---
-- Contains the raw cubescript contents of a variable.
--
-- @type ExtractedVariable
--
local ExtractedVariable = ExtractedDocumentableContent:extend()


-- Public Methods

---
-- Extracts the variable from the file contents in which it's pattern was found.
--
-- @tparam string _fileContents The file contents in which the pattern was found
--
-- @treturn int The first position after the variable's end position in the file contents
--
function ExtractedVariable:extractFromFileContents(_fileContents)

  local newSearchOffset = ExtractedDocumentableContent.extractFromFileContents(self, _fileContents)

  local trailingComment = self:extractTrailingComment(_fileContents)
  if (trailingComment) then
    self.docBlock = self.docBlock .. "\n" .. trailingComment
  end

  return newSearchOffset

end


-- Protected Methods

---
-- Returns the body start and end position of the variable from the file contents.
--
-- @tparam string _fileContents The file contents
--
-- @treturn int, int The body start and end position
--
function ExtractedVariable:getBodyPosition(_fileContents)

  local firstCharacterPosition = self.patternEndPosition + 1
  local firstContentCharacter = _fileContents:sub(firstCharacterPosition, firstCharacterPosition)

  local searchOffset = firstCharacterPosition + 1
  local contentStartPosition = firstCharacterPosition
  local contentEndPosition
  local contentHasDelimiters = false

  if (firstContentCharacter == "[") then
    contentHasDelimiters = true
    contentEndPosition = _fileContents:find("%]", searchOffset) - 1
  elseif (firstContentCharacter == "\"") then
    contentHasDelimiters = true
    contentEndPosition = _fileContents:find("\"", searchOffset) - 1
  elseif (firstContentCharacter == "(") then
    contentHasDelimiters = true
    contentEndPosition = _fileContents:find("%)", searchOffset) - 1
  else
    -- No delimiters were used, the content end is the next whitespace or semicolon
    if (searchOffset >= #_fileContents) then
      contentEndPosition = searchOffset
    else
      contentEndPosition = _fileContents:find("[ ;\n]", searchOffset) - 1
    end

  end

  if (contentHasDelimiters) then
    contentStartPosition = contentStartPosition + 1
  end


  return contentStartPosition, contentEndPosition

end

---
-- Extracts a trailing comment behind the variable's body from the file contents.
--
-- @tparam string _fileContents The file contents
--
-- @treturn string The trailing comment behind the variable's body or nil if there is no trailing comment
--
function ExtractedVariable:extractTrailingComment(_fileContents)
  return _fileContents:sub(self.bodyEndPosition + 1):match("^[^/\n]*(//[^\n]*)")
end


return ExtractedVariable
