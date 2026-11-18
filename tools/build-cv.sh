#!/usr/bin/env bash
# Genera cv/CV-JoseLuisDominguezRondan-{ES,EN}.pdf imprimiendo index.html con Chrome/Edge en modo headless.
# Uso (Git Bash):  bash tools/build-cv.sh
# Vuelve a ejecutarlo cada vez que cambies el contenido de index.html.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/cv"

BROWSER=""
for c in "/c/Program Files/Google/Chrome/Application/chrome.exe" \
         "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
         "/c/Program Files/Microsoft/Edge/Application/msedge.exe"; do
  [ -x "$c" ] && BROWSER="$c" && break
done
[ -n "$BROWSER" ] || { echo "No se encontró Chrome ni Edge" >&2; exit 1; }

PAGE_URL="file:///$(cygpath -m "$ROOT/index.html")"
PROFILE="$(mktemp -d)"
trap 'rm -rf "$PROFILE"' EXIT

for LANG_CODE in es en; do
  OUT="$ROOT/cv/CV-JoseLuisDominguezRondan-${LANG_CODE^^}.pdf"
  "$BROWSER" --headless=new --disable-gpu --no-first-run --user-data-dir="$(cygpath -w "$PROFILE")" \
    --no-pdf-header-footer --virtual-time-budget=3000 \
    --print-to-pdf="$(cygpath -w "$OUT")" "${PAGE_URL}?lang=${LANG_CODE}" 2>/dev/null
  echo "Generado: cv/$(basename "$OUT")"
done
