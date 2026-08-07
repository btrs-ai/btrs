#!/bin/bash
# btrs core context loader — one round trip instead of several Reads.
#
# Emits the shared protocol files a skill needs at Step 0. Loading them with
# separate Read calls costs one full context re-send each; this cats them in one.
#
# Idempotent per session per directory: a marker records what has been loaded,
# and a repeat call for the same mode is a silent no-op — skills call this
# unconditionally, no separate check script needed.
#
# Usage:
#   btrs-load-core.sh --build      # rigor (implementation work)
#   btrs-load-core.sh --review     # verification checklist
#   btrs-load-core.sh --lifecycle  # workflow/status display (deploy, health)
#   btrs-load-core.sh --all        # everything (rare; prefer a narrower set)

set -uo pipefail

SHARED="$HOME/.claude/btrs/skills/shared"
MODE="${1:---build}"
MARKER="/tmp/btrs-context-$(echo "$(pwd)" | shasum -a 256 | cut -c1-12)"

# HIT: already loaded this session — do not re-emit.
if [ -f "$MARKER" ] && { grep -qx -- "$MODE" "$MARKER" || grep -qx -- "--all" "$MARKER"; }; then
  echo "HIT: $MODE already in context — nothing loaded, do not re-read."
  exit 0
fi

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
  --all)
    emit config.md
    emit rigor-protocol.md
    emit verification-protocol.md
    emit workflow-protocol.md
    ;;
  *)
    echo "unknown mode: $MODE (use --build|--review|--lifecycle|--all)" >&2
    exit 2
    ;;
esac

# Record what is now in context so later calls no-op.
echo "$MODE" >> "$MARKER"

echo ""
echo "Loaded above — do not re-read these files this session."
echo "=== END BTRS CORE CONTEXT ==="
