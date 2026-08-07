#!/bin/bash
# btrs context check — has this protocol set already been loaded this session?
#
# Routed skills call this at Step 0. HIT means the text is already in context
# from an earlier btrs-load-core.sh call; skip the load and save a round trip
# plus a full re-send of the protocol file.
#
# Usage: btrs-check-context.sh --build   ->  "HIT" or "MISS"

set -uo pipefail

MODE="${1:---build}"
MARKER="/tmp/btrs-context-$(echo "$(pwd)" | shasum -a 256 | cut -c1-12)"

if [ -f "$MARKER" ] && { grep -qx -- "$MODE" "$MARKER" || grep -qx -- "--all" "$MARKER"; }; then
  echo "HIT ($MODE already in context — do not re-load)"
else
  echo "MISS ($MODE not loaded — run: bash ~/.claude/btrs/skills/shared/btrs-load-core.sh $MODE)"
fi
