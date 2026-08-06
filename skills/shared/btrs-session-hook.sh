#!/bin/bash
# BTRS Session Hook — UserPromptSubmit
#
# Injects a lean routing trigger when BTRS is active for this directory.
#
# Intentionally NOT scope-gated: the marker is the authority. SessionStart sets
# it automatically inside BTRS_SCOPE, and an explicit /btrs sets it anywhere.
# Gating here would break explicit invocation from outside the scope.

PROJECT_DIR="$(pwd)"
HASH="$(echo "$PROJECT_DIR" | shasum -a 256 | cut -c1-12)"
SESSION_MARKER="/tmp/btrs-session-$HASH"
ROUTED_MARKER="/tmp/btrs-routed-$HASH"

if [ -f "$SESSION_MARKER" ] && [ ! -f "$ROUTED_MARKER" ]; then
  touch "$ROUTED_MARKER"
  # Fire once per session. The routing table enters context on the first
  # routed message; re-reading SKILL.md on every prompt would re-load the
  # same content each turn for no benefit.
  echo "[BTRS] Route this message: classify and dispatch using the BTRS routing table. If it is not already in context, read ~/.claude/btrs/skills/btrs/SKILL.md Step 1 — otherwise do not re-read it."
fi
