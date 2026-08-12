#!/bin/bash
set -e

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
SVG="$(cd "$(dirname "$0")" && pwd)/Icon.svg"
OUT="$(cd "$(dirname "$0")/.." && pwd)/Sources/macOS/ModernKey/Resources/Icon.icns"
WORK="$(mktemp -d)"
ICONSET="$WORK/Icon.iconset"

if [ ! -x "$CHROME" ]; then
  echo "✗ Google Chrome not found at $CHROME"
  exit 1
fi

mkdir -p "$ICONSET"

render() {
  local size=$1 name=$2
  cat > "$WORK/page.html" <<HTML
<!doctype html>
<style>html,body{margin:0;padding:0;background:transparent}svg{display:block;width:${size}px;height:${size}px}</style>
$(cat "$SVG")
HTML
  "$CHROME" --headless --disable-gpu --hide-scrollbars \
    --default-background-color=00000000 \
    --force-device-scale-factor=1 \
    --window-size="$size,$size" \
    --screenshot="$ICONSET/$name" \
    "$WORK/page.html" >/dev/null 2>&1
  echo "  $name (${size}px)"
}

echo "→ Rendering $SVG"
render 16 icon_16x16.png
render 32 icon_16x16@2x.png
render 32 icon_32x32.png
render 64 icon_32x32@2x.png
render 128 icon_128x128.png
render 256 icon_128x128@2x.png
render 256 icon_256x256.png
render 512 icon_256x256@2x.png
render 512 icon_512x512.png
render 1024 icon_512x512@2x.png

echo "→ Building icns"
iconutil -c icns "$ICONSET" -o "$OUT"
rm -rf "$WORK"

echo "✓ Done: $OUT"
