#!/usr/bin/env bash
# 全スライドを日英両方でスクリーンショットする（ヘッドレス Chrome）。
# 使い方: scripts/screenshot.sh [deck.html] [出力ディレクトリ]
set -euo pipefail

deck="${1:-template.html}"
out="${2:-screenshots}"
chrome="${CHROME:-}"
if [ -z "$chrome" ]; then
  for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" google-chrome chromium chromium-browser; do
    if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then chrome="$c"; break; fi
  done
fi
[ -n "$chrome" ] || { echo "Chrome が見つかりません。CHROME=/path/to/chrome を指定してください" >&2; exit 1; }

n=$(grep -c '<section class="slide' "$deck")
path="$(cd "$(dirname "$deck")" && pwd)/$(basename "$deck")"
mkdir -p "$out"
for lang in ja en; do
  for i in $(seq 1 "$n"); do
    # 高さ 944 = スライド 900 + ナビ 44。描画とフォント読み込みを待つため virtual-time-budget を付ける
    "$chrome" --headless=new --disable-gpu --hide-scrollbars --window-size=1600,944 \
      --virtual-time-budget=3000 --screenshot="$out/$lang-$(printf %02d "$i").png" \
      "file://$path?lang=$lang#s$i" >/dev/null 2>&1
  done
done
echo "$n 枚 × 2 言語を $out/ に保存しました"
