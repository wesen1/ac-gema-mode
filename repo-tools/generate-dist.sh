#!/bin/bash

workingDirectory="$(pwd)"
scriptCallPath="$(dirname $0)"

if [[ "$pathString" == "/"* ]]; then
  absoluteScriptCallPath="$scriptCallPath"
else
  absoluteScriptCallPath="$workingDirectory/$scriptCallPath"
fi

generateDistPath="$absoluteScriptCallPath/generate-dist"
scriptsDirectoryPath="$absoluteScriptCallPath/../"

cd "$generateDistPath"
lua generate-dist.lua --scriptsDirectoryPath "$scriptsDirectoryPath" --entryPointScriptPath "ac-gema-mode.cfg" --outputFilePath "$scriptsDirectoryPath/ac-gema-mode-dist.cfg"
