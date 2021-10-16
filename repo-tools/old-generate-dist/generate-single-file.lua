---
-- @author wesen
-- @copyright 2020 wesen <wesen-ac@web.de>
-- @release 0.1
-- @license MIT
--

local allowedCharacters = {
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
  "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
  "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "_", "-", "#", "'", "`", "?", "!"
}
local currentConstantName = { 1 }

local builtinIdents = {

  -- Found via `grep -rPoh "(?<=identexists\()([^ )]+)(?= *\))" | sort -u`
  "afterinit",
  "KEYPRESS",
  "KEYRELEASE",
  "modmdlbounce3",
  "newselkeys",
  "onAttack",
  "onCallVote",
  "onChangeVote",
  "onConnect",
  "onDisconnect",
  "onFlag",
  "onHit",
  "onKill",
  "onLastMin",
  "onNameChange",
  "onNewMap",
  "onPickup",
  "onPM",
  "onReload",
  "onSpawn",
  "onVoteEnd",
  "onWeaponSwitch",
  "sbconnect",
  "start_intermission",

  -- Found via `grep -r identexists`
  "modmdlbounce%d",
  "modmdlpickup%d",
  "modmdlweap%d",
  "modmdlvwep%d",


  -- Found via `grep -rPoh "(?<=getalias\()[^\(\) ]+(?= *\))" | sort -u`
  "HIGHLIGHT",
  "_kickbanreason",
  "mapstartalways",
  "mapstartonce",
  "onQuit",
  "openaldevice",

  -- Found via `grep -r getalias`
  "nextmap_%s",
  "sbfavourite_%s_%s"

}

function increaseConstantName()
  increasePosition(#currentConstantName)
end

function increasePosition(_position)

  if (currentConstantName[_position] == #allowedCharacters) then

    if (_position == 1) then
      table.insert(currentConstantName, 1, 1)
    else
      currentConstantName[_position] = 1
      increasePosition(_position - 1)
    end
  else
    currentConstantName[_position] = currentConstantName[_position] + 1
  end

end

function buildConstantName()

  local constantName = ""
  for _, characterNumber in ipairs(currentConstantName) do
    constantName = constantName .. allowedCharacters[characterNumber]
  end

  return constantName

end


local excludeMethodNames = { "showGemaModeMenu" }

local prefix = "gema"
for constantName in minifiedFile:gmatch("const ([^ ]+)") do

  local isExcludeMethodName = false
  for _, excludeMethodName in ipairs(excludeMethodNames) do

    if (constantName == excludeMethodName) then
      isExcludeMethodName = true
      break
    end

  end

  if (not isExcludeMethodName) then
    local replacementName = prefix .. buildConstantName()
    minifiedFile = minifiedFile:gsub("const (" .. constantName .. ")", replacementName)
    minifiedFile = minifiedFile:gsub("$" .. constantName .. "[ )]", replacementName)

    increaseConstantName()
  end

end


-- TODO: List of preserved names that may not be replaced and new names may not match these
-- TODO: Replace alias <name> <string> by <name> = <string>
