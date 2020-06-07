---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local Object = require "classic"

---
-- Base class for extracted documentable cubescript content.
--
-- @type ExtractedDocumentableContent
--
local ExtractedDocumentableContent = Object:extend()


---
-- The pattern by which this documentable content was found in the cubescript code
--
-- @tfield string pattern
--
ExtractedDocumentableContent.pattern = nil

---
-- The start position of the pattern in the cubescript code in which this documentable content was found
--
-- @tfield int patternStartPosition
--
ExtractedDocumentableContent.patternStartPosition = nil

---
-- The end position of the pattern in the cubescript code in which this documentable content was found
--
-- @tfield int patternEndPosition
--
ExtractedDocumentableContent.patternEndPosition = nil

---
-- The name of this documentable content
--
-- @tfield string name
--
ExtractedDocumentableContent.name = nil

---
-- The doc block
--
-- @tfield string docBlock
--
ExtractedDocumentableContent.docBlock = nil

---
-- The body
--
-- @tfield string body
--
ExtractedDocumentableContent.body = nil

---
-- The end position of the body in the cubescript code in which this documentable content was found
--
-- @tield int bodyEndPosition
--
ExtractedDocumentableContent.bodyEndPosition = nil


---
-- ExtractedDocumentableContent constructor.
--
-- @tparam string _pattern The pattern by which this documentable content was found in the cubescript code
-- @tparam int _patternStartPosition The start position of the pattern in the cubescript code
-- @tparam int _patternEndPosition The end position of the pattern in the cubescript code
--
function ExtractedDocumentableContent:new(_pattern, _patternStartPosition, _patternEndPosition)
  self.pattern = _pattern
  self.patternStartPosition = _patternStartPosition
  self.patternEndPosition = _patternEndPosition
end


-- Getters and Setters

---
-- Returns the extracted documentable content's name.
--
-- @treturn string The name
--
function ExtractedDocumentableContent:getName()
  return self.name
end

---
-- Returns the doc block.
--
-- @treturn string The doc block
--
function ExtractedDocumentableContent:getDocBlock()
  return self.docBlock
end

---
-- Returns the body.
--
-- @treturn string The body
--
function ExtractedDocumentableContent:getBody()
  return self.body
end


-- Public Methods

---
-- Extracts this documentable content from the file contents in which it's pattern was found.
--
-- @tparam string _fileContents The file contents in which the pattern was found
--
-- @treturn int The first position after this documentable content's end position in the file contents
--
function ExtractedDocumentableContent:extractFromFileContents(_fileContents)

  self.name = self:extractName(_fileContents)
  self.body = self:extractBody(_fileContents)
  self.docBlock = self:extractDocBlock(_fileContents)

  return self.bodyEndPosition + 1

end


-- Private Methods

---
-- Extracts the name from the file contents.
--
-- @tparam string _fileContents The file contents to extract the name from
--
-- @treturn string The extracted name
--
function ExtractedDocumentableContent:extractName(_fileContents)
  local remainingFileContents = _fileContents:sub(self.patternStartPosition)
  return remainingFileContents:match(self.pattern)
end

---
-- Extracts the doc block that preceeds this documentable content's name.
--
-- @tparam string _fileContents The file contents to extract the doc block from
--
-- @treturn string The extracted doc block
--
function ExtractedDocumentableContent:extractDocBlock(_fileContents)

  local fileContentsBeforePatternStart = _fileContents:sub(1, self.patternStartPosition)
  local reverseFileContentsBeforePatternStart = fileContentsBeforePatternStart:reverse()

  local docBlockLinePattern = "\n[^\n]*// *[\n$]"

  local stringOffset = 1
  local startPosition, endPosition

  repeat

    startPosition, endPosition = reverseFileContentsBeforePatternStart:find(docBlockLinePattern, stringOffset)

    if (startPosition == stringOffset) then
      -- The end position includes the \n which shall be the start for the next search
      stringOffset = endPosition
    else
      break
    end

  until (not startPosition)


  return reverseFileContentsBeforePatternStart:sub(1, stringOffset):reverse()

end

---
-- Extracts the body from the file contents.
--
-- @tparam string _fileContents The file contents to extract the body from
--
-- @treturn string The extracted body
--
function ExtractedDocumentableContent:extractBody(_fileContents)

  local bodyStartPosition, bodyEndPosition = self:getBodyPosition(_fileContents)
  self.bodyEndPosition = bodyEndPosition

  return _fileContents:sub(bodyStartPosition, self.bodyEndPosition)

end


-- Protected Methods

---
-- Returns the body start and end position of this documentable content from the file contents.
--
-- @tparam string _fileContents The file contents
--
-- @treturn int, int The body start and end position
--
function ExtractedDocumentableContent:getBodyPosition(_fileContents)
end


return ExtractedDocumentableContent
