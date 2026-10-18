#!/bin/sh
# Optimise images from originals/ into optimised/ as resized WebP.
# Usage: scripts/optimise-image.sh [src_dir] [out_dir]
# Env:   MAX_SIZE (longest side, default 1600), QUALITY (default 80), FORCE=1 to rebuild all
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:-$ROOT/assets/images/originals}"
OUT="${2:-$ROOT/assets/images/optimised}"
MAX_SIZE="${MAX_SIZE:-1600}"
QUALITY="${QUALITY:-80}"
FORCE="${FORCE:-0}"

mkdir -p "$OUT"

for src in "$SRC"/*; do
  [ -f "$src" ] || continue
  case "$(printf '%s' "$src" | tr '[:upper:]' '[:lower:]')" in
    *.jpg|*.jpeg|*.png|*.webp|*.heic|*.tif|*.tiff) ;;
    *) continue ;;
  esac

  # "IP Logs.jpeg" -> "ip-logs.webp"
  name="$(basename "$src")"
  slug="$(printf '%s' "${name%.*}" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//; s/-$//')"
  out="$OUT/$slug.webp"

  if [ "$FORCE" != 1 ] && [ "$out" -nt "$src" ]; then
    continue
  fi

  # -auto-orient before -strip, otherwise camera photos lose their rotation
  magick "$src" -auto-orient -strip -resize "${MAX_SIZE}x${MAX_SIZE}>" -quality "$QUALITY" "$out"

  before=$(wc -c < "$src")
  after=$(wc -c < "$out")
  printf '%-24s -> %-22s %6s KB -> %5s KB\n' "$name" "$slug.webp" $((before / 1024)) $((after / 1024))
done
