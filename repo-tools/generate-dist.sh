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


if [ ! -d "$scriptsDirectoryPath/dist" ]; then
  mkdir "$scriptsDirectoryPath/dist"
fi

generateDistCommand="lua generate-dist.lua --scriptsDirectoryPath $scriptsDirectoryPath --entryPointScriptPath ac-gema-mode.cfg"

generateDistWithDocsCommand="$generateDistCommand --outputFilePath $scriptsDirectoryPath/dist/ac-gema-mode-dist-with-docs.cfg"
generateDistWithoutDocsCommand="$generateDistCommand --outputFilePath $scriptsDirectoryPath/dist/ac-gema-mode-dist.cfg --ignoreDocs"


cd "$generateDistPath"
$generateDistWithDocsCommand
$generateDistWithoutDocsCommand
