#!/usr/bin/env bash
# スライドごとに <div> と </div> の数が合っているかを調べる。
# 閉じタグが 1 つ多いだけで、それ以降のスライドが縮小の対象から外れて崩れる。
# 使い方: scripts/check.sh [deck.html]
set -euo pipefail
deck="${1:-template.html}"
python3 - "$deck" <<'PY'
import re, sys
s = open(sys.argv[1], encoding="utf-8").read()
bad = 0
for k, sec in enumerate(re.findall(r'<section class="slide[^>]*>.*?</section>', s, flags=re.S), 1):
    o, c = len(re.findall(r'<div\b', sec)), len(re.findall(r'</div>', sec))
    if o != c:
        bad += 1
        print(f"{k} 枚目: <div> {o} 個に対して </div> {c} 個", file=sys.stderr)
if bad:
    sys.exit(1)
print("タグの対応: 問題なし")
PY
