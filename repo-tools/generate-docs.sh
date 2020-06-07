#!/bin/bash

workingDirectory="$(pwd)"
scriptCallPath="$(dirname $0)"

if [[ "$pathString" == "/"* ]]; then
  absoluteScriptCallPath="$scriptCallPath"
else
  absoluteScriptCallPath="$workingDirectory/$scriptCallPath"
fi

generateDocsPath="$absoluteScriptCallPath/generate-docs"
sourceDirectoryPath="$absoluteScriptCallPath/../ac-gema-mode"

cd "$generateDocsPath"
lua generate-docs.lua --sourceDirectoryPath "$sourceDirectoryPath" --namespace "ac-gema-mode" --outputFilePath "$sourceDirectoryPath/docs.cfg"
