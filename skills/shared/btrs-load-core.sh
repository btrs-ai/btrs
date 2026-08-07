#!/bin/bash
# btrs core context loader — one round trip instead of several Reads.
#
# Emits the shared protocol files a skill needs at Step 0. Loading them with
# separate Read calls costs one full context re-send each; this cats them in one.
#
# On success it writes a per-directory context marker, so a skill routed to
# later in the same session can call btrs-check-context.sh, get HIT, and skip
# re-loading protocol text that is already in context.
#
# Usage:
#   btrs-load-core.sh --build      # rigor (implementation work)
#   btrs-load-core.sh --review     # verification checklist
#   btrs-load-core.sh --lifecycle  # workflow/status display (deploy, health)
#   btrs-load-core.sh --paths      # vault layout + output paths
#   btrs-load-core.sh --all        # everything (rare; prefer a narrower set)

set -uo pipefail

SHARED="$HOME/.claude/btrs/skills/shared"
MODE="${1:---build}"
HASH="$(echo "$(pwd)" | shasum -a 256 | cut -c1-12)"

emit() {
  local f="$SHARED/$1"
  if [ -f "$f" ]; then
    echo ""
    echo "--- $1 ---"
    cat "$f"
  else
    echo "WARN: missing $1" >&2
  fi
}

echo "=== BTRS CORE CONTEXT ($MODE) ==="
case "$MODE" in
  --build)     emit rigor-protocol.md ;;
  --review)    emit verification-protocol.md ;;
  --lifecycle) emit workflow-protocol.md ;;
  --paths)     emit config.md ;;
  --all)
    emit config.md
    emit rigor-protocol.md
    emit verification-protocol.md
    emit workflow-protocol.md
    ;;
  *)
    echo "unknown mode: $MODE (use --build|--review|--lifecycle|--paths|--all)" >&2
    exit 2
    ;;
esac

# Record what is now in context so downstream skills can skip re-loading.
echo "$MODE" >> "/tmp/btrs-context-$HASH"

echo ""
echo "Loaded above — do not re-read these files this session."
echo "=== END BTRS CORE CONTEXT ==="
