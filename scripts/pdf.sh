#!/usr/bin/env bash
# デッキを PDF に書き出す（1 ページ 1 スライド、1600×900）。印刷用の CSS は template.html にある。
# 使い方: scripts/pdf.sh [deck.html] [出力.pdf] [ja|en]
set -euo pipefail

deck="${1:-template.html}"
out="${2:-${deck%.html}.pdf}"
lang="${3:-ja}"
chrome="${CHROME:-}"
if [ -z "$chrome" ]; then
  for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" google-chrome chromium chromium-browser; do
    if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then chrome="$c"; break; fi
  done
fi
[ -n "$chrome" ] || { echo "Chrome が見つかりません。CHROME=/path/to/chrome を指定してください" >&2; exit 1; }

path="$(cd "$(dirname "$deck")" && pwd)/$(basename "$deck")"
outabs="$(cd "$(dirname "$out")" && pwd)/$(basename "$out")"
"$chrome" --headless=new --disable-gpu --no-pdf-header-footer --virtual-time-budget=6000 \
  --print-to-pdf="$outabs" "file://$path?lang=$lang" >/dev/null 2>&1
echo "$outabs に保存しました"
