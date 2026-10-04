#!/bin/bash

for theme in $(vivid themes); do
  echo "=== Theme: $theme ==="
  LS_COLORS=$(vivid generate $theme) ls --color=always -la "${1:-.}"
  echo ""
  read -p "Press Enter for next theme..."  # Optional: pauses to let you see each one
done
