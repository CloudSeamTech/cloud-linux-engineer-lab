#!/usr/bin/env bash
# verify-audio.sh — run from the repo root after each recording batch.
# Compares audio/ against audio_manifest.csv:
#   - shows progress (n of 92)
#   - lists clips still TO DO
#   - flags files in audio/ whose names don't match the manifest (typos/unrenamed)

set -euo pipefail
MANIFEST="audio_manifest.csv"
AUDIO_DIR="audio"

[ -f "$MANIFEST" ] || { echo "Run from the repo root ($MANIFEST not found)."; exit 1; }
mkdir -p "$AUDIO_DIR"

# expected filenames = 2nd CSV column, skip header
expected=$(awk -F',' 'NR>1 {print $2}' "$MANIFEST" | tr -d '"')
total=$(echo "$expected" | wc -l | tr -d ' ')

have=0; missing=()
while IFS= read -r f; do
  if [ -f "$AUDIO_DIR/$f" ]; then have=$((have+1)); else missing+=("$f"); fi
done <<< "$expected"

echo "Progress: $have / $total clips recorded"
if [ ${#missing[@]} -gt 0 ]; then
  echo; echo "Still to do (in play order):"
  printf '  %s\n' "${missing[@]}"
fi

# anything in audio/ that ISN'T in the manifest = typo or unrenamed download
echo
stray=0
for f in "$AUDIO_DIR"/*.mp3; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  if ! grep -q ",${base}," <(awk -F',' 'NR>1 {print ","$2","}' "$MANIFEST" | tr -d '"'); then
    [ $stray -eq 0 ] && echo "⚠ Files that don't match any manifest name (typo or not yet renamed):"
    echo "  $base"; stray=1
  fi
done
[ $stray -eq 0 ] && echo "No stray/misnamed files. ✔"
