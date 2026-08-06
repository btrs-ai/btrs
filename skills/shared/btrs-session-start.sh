#!/bin/bash
# BTRS Session Start Hook — SessionStart
#
# Auto-activates BTRS routing when the session opens inside BTRS_SCOPE.
# Outside that scope the marker is cleared, leaving BTRS dormant until the
# user explicitly types /btrs (which works from any directory).

PROJECT_DIR="$(pwd)"
HASH="$(echo "$PROJECT_DIR" | shasum -a 256 | cut -c1-12)"
MARKER="/tmp/btrs-session-$HASH"
ROUTED_MARKER="/tmp/btrs-routed-$HASH"

# Always clear the once-per-session routing marker so the trigger fires again.
rm -f "$ROUTED_MARKER" 2>/dev/null

# Load scope config (default: ~/PERSONAL)
SCOPE_FILE="$HOME/.claude/btrs/scope.conf"
if [ -f "$SCOPE_FILE" ]; then
  # shellcheck source=/dev/null
  source "$SCOPE_FILE"
fi
BTRS_SCOPE="${BTRS_SCOPE:-$HOME/PERSONAL}"
# Expand a literal $HOME/~ written in the config file
BTRS_SCOPE="${BTRS_SCOPE/#\~/$HOME}"

if [[ "$PROJECT_DIR" == "$BTRS_SCOPE" || "$PROJECT_DIR" == "$BTRS_SCOPE"/* ]]; then
  # In scope — activate routing for this session.
  touch "$MARKER" 2>/dev/null
else
  # Out of scope — start dormant. /btrs re-activates on demand.
  rm -f "$MARKER" 2>/dev/null
fi
