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

luaCommand="lua generate-dist.lua --scriptsDirectoryPath $scriptsDirectoryPath --entryPointScriptPath ac-gema-mode.cfg --outputFilePath $scriptsDirectoryPath/ac-gema-mode-dist.cfg"

if [ "$#" -gt 0 -a "$1" == "--ignoreDocs" ]; then
  luaCommand="$luaCommand --ignoreDocs"
fi

cd "$generateDistPath"
$luaCommand
