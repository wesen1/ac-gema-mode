#!/bin/bash

if [ "$#" -ne "1" ]; then
  echo "Usage: ./prepare-release.sh <new_version_number>"
  exit 1
fi


workingDirectory="$(pwd)"
scriptCallPath="$(dirname $0)"

if [[ "$pathString" == "/"* ]]; then
  absoluteScriptCallPath="$scriptCallPath"
else
  absoluteScriptCallPath="$workingDirectory/$scriptCallPath"
fi

newVersionNumber="$1"
versionInfoScriptFilePath="$absoluteScriptCallPath/../ac-gema-mode/version-info.cfg"

sed -ri "s/(const AC_GEMA_MODE_VERSION ).*;/\1$newVersionNumber;/g" "$versionInfoScriptFilePath"

./update-translations.sh
./generate-docs.sh
./generate-dist.sh
