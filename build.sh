#!/bin/bash
set -e

PROJECT="Sources/OpenKey/macOS/Mkey.xcodeproj"
SCHEME="Mkey"
DERIVED="build/DerivedData"
APP_PATH="$DERIVED/Build/Products/Release/Mkey.app"
DMG_STAGING="build/dmg_staging"
DMG_OUT="build/Mkey.dmg"

echo "→ Building..."
xcodebuild -project "$PROJECT" \
           -scheme "$SCHEME" \
           -configuration Release \
           -derivedDataPath "$DERIVED" \
           clean build \
           | grep -E "error:|warning:|BUILD SUCCEEDED|BUILD FAILED"

echo "→ Stripping quarantine..."
xattr -cr "$APP_PATH"

echo "→ Re-signing..."
codesign --force --deep --sign - "$APP_PATH"

echo "→ Packaging DMG..."
rm -rf "$DMG_STAGING" "$DMG_OUT"
mkdir -p "$DMG_STAGING"
cp -r "$APP_PATH" "$DMG_STAGING/"
ln -s /Applications "$DMG_STAGING/Applications"
hdiutil create -volname "Mkey" -srcfolder "$DMG_STAGING" -ov -format UDZO "$DMG_OUT"

echo "✓ Done: $DMG_OUT"
