#!/bin/bash

workingDirectory="$(pwd)"
scriptCallPath="$(dirname $0)"

if [[ "$pathString" == "/"* ]]; then
  absoluteScriptCallPath="$scriptCallPath"
else
  absoluteScriptCallPath="$workingDirectory/$scriptCallPath"
fi

updateTranslationsPath="$absoluteScriptCallPath/update-translations"
stringsDirectoryPath="$absoluteScriptCallPath/../ac-gema-mode/strings"
languages="de"

cd "$updateTranslationsPath"
lua update-translations.lua --stringsDirectoryPath "$stringsDirectoryPath" --languages "$languages"
