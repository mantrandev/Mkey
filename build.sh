#!/bin/bash
set -eo pipefail

if ! command -v create-dmg >/dev/null 2>&1; then
  echo "✗ create-dmg chưa cài. Chạy: brew install create-dmg" >&2
  exit 1
fi

PROJECT="Sources/macOS/Mkey.xcodeproj"
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

echo "→ Stripping symbols..."
strip -x "$APP_PATH/Contents/MacOS/$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$APP_PATH/Contents/Info.plist")"

echo "→ Re-signing..."
codesign --force --deep --sign - "$APP_PATH"

echo "→ Packaging DMG..."
rm -rf "$DMG_STAGING" "$DMG_OUT"
mkdir -p "$DMG_STAGING"
cp -r "$APP_PATH" "$DMG_STAGING/"
create-dmg \
  --volname "Mkey" \
  --window-pos 200 120 \
  --window-size 500 300 \
  --icon-size 100 \
  --icon "Mkey.app" 125 150 \
  --app-drop-link 375 150 \
  --no-internet-enable \
  "$DMG_OUT" \
  "$DMG_STAGING/"

echo "✓ Done: $DMG_OUT"
