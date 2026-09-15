#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DESTINATION="$HOME/Applications/Codex Limit.app"
BUILT_APP="$SCRIPT_DIR/.build/Build/Products/Release/Codex Limit.app"
WIDGET="$BUILT_APP/Contents/PlugIns/Codex Limit Widget.appex"
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister"

cd "$SCRIPT_DIR"
xcodegen generate
xcodebuild \
    -project CodexLimit.xcodeproj \
    -scheme CodexLimit \
    -configuration Release \
    -derivedDataPath .build \
    clean build

test "$(plutil -extract NSExtension.NSExtensionPointIdentifier raw "$WIDGET/Contents/Info.plist")" = \
    "com.apple.widgetkit-extension"

mkdir -p "$HOME/Applications"
ditto "$BUILT_APP" "$DESTINATION"
"$LSREGISTER" -f -R -trusted "$DESTINATION"
pluginkit -a "$DESTINATION/Contents/PlugIns/Codex Limit Widget.appex"
open "$DESTINATION"

printf 'Installed: %s\n' "$DESTINATION"
