#!/usr/bin/lua

---
-- @author wesen
-- @copyright 2019-2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

---
-- Converts a AssaultCube font config to a file that returns a cubescript list that contains
-- the width of each character.
-- You can find the font configs in the config directory of your AssaultCube installation,
-- they are named "font_<font name>.cfg".
--
-- The tab width can be found in "src/protos.h" as "PIXELTAB" and the default width usage can be found
-- in "src/rendertext.cpp".
--

-- Functions

---
-- Parses a font config file and returns the result.
--
-- @tparam string _fontConfigFilePath The path to the font config file
--
-- @treturn table The parsed font config
--
local function parseFontConfig(_fontConfigFilePath)

  local parsedFontConfig = { ["symbolWidths"] = {} }

  for line in io.lines(_fontConfigFilePath) do

    if (line:find("font ")) then

      -- Extract the font name and default width
      -- The font command structure is:
      --   font <name> <path to texture> <default width> <default height> ...
      local fontName, defaultWidth = line:match("font (.*) \".*\" (%d+) %d+ *.*")
      parsedFontConfig["fontName"] = fontName
      parsedFontConfig["defaultWidth"] = defaultWidth

      -- A whitespace's width equals the default width - 1 (see rendertext.cpp)
      parsedFontConfig["symbolWidths"][" "] = defaultWidth -1

      -- A tab's width equals the default width * 10 (see protos.h)
      parsedFontConfig["symbolWidths"]["\t"] = defaultWidth * 10

    elseif (line:find("fontchar")) then

      -- The fontchar command structure is:
      --   fontchar <x> <y> <width> <height>
      -- If width or height are not set they are replaced by the default values
      local symbol = line:match("// (.)")
      local width = line:match("fontchar[ \t]+%d+[ \t]+%d+[ \t]+(%d+)[ \t]*.*")
      if (not width) then
        width = parsedFontConfig["defaultWidth"]
      end
      parsedFontConfig["symbolWidths"][symbol] = width
    end

  end

  return parsedFontConfig

end

---
-- Generates a cubescript file from a parsed font config.
--
-- @tparam table _parsedFontConfig The parsed font config
-- @tparam string _outputFilePath The output file path
--
local function generateCubescriptFileFromParsedFontConfig(_parsedFontConfig, _outputFilePath)

  -- Get sorted symbols
  local specialSymbols = {
    QUOTE = _parsedFontConfig["symbolWidths"]["\""],
    TAB = _parsedFontConfig["symbolWidths"]["\t"]
  }

  _parsedFontConfig["symbolWidths"]["\""] = nil
  _parsedFontConfig["symbolWidths"]["\t"] = nil

  local symbols = {}
  for symbol, _ in pairs(_parsedFontConfig["symbolWidths"]) do
    table.insert(symbols, symbol)
  end
  table.sort(symbols)


  local fontName = _parsedFontConfig["fontName"]
  local listName = "font" .. fontName:sub(1, 1):upper() .. fontName:sub(2) .. "CharacterWidths"

  -- Open the output file in write mode
  local outputFile = io.open(_outputFilePath, "w")

  -- Write the header docblock
  outputFile:write("//\n")
  outputFile:write("// Auto generated font config table for font \"" .. fontName .. "\".\n")
  outputFile:write("//\n\n")

  outputFile:write("const " .. listName .. " [\n")
  for _, symbol in ipairs(symbols) do

    local width = _parsedFontConfig["symbolWidths"][symbol]

    if (symbol == " " or symbol == "[" or symbol == "]") then
      -- The symbol is a special character that needs to be enclosed in double quotes
      symbol = "\"" .. symbol .. "\""
    end
    outputFile:write("  " .. symbol .. " " .. width .. "\n")

  end

  for specialSymbolName, specialSymbolWidth in pairs(specialSymbols) do
    outputFile:write("  " .. specialSymbolName .. " " .. specialSymbolWidth .. "\n")
  end

  outputFile:write("]\n")
  outputFile:close()

end


-- Script

local fontConfigFilePath = "./font_default.cfg"
if (arg[1]) then
  fontConfigFilePath = arg[1]
end

print("\nAssaultCube font config converter v0.0.1\n");
print("Usage: ./convert-font-config.lua [font config file path]\n");
print("Configuration:\n");
print("  font config file path: " .. fontConfigFilePath .. "\n\n");

print("Parsing \"" .. fontConfigFilePath .. "\" ... ")
local parsedFontConfig = parseFontConfig(fontConfigFilePath)
print("DONE\n")

-- Generate the output file path
local fontName = parsedFontConfig["fontName"]
local outputFilePath = "./font-" .. fontName .. "-character-widths.cfg"

print("Generating output file \"" .. outputFilePath .. "\" ... ")
generateCubescriptFileFromParsedFontConfig(parsedFontConfig, outputFilePath)
print("DONE\n")
