#!/bin/bash
# BTRS Session Hook — UserPromptSubmit
# Injects lean routing trigger when a session is active.

PROJECT_DIR="$(pwd)"
MARKER="/tmp/btrs-session-$(echo "$PROJECT_DIR" | shasum -a 256 | cut -c1-12)"

if [ -f "$MARKER" ]; then
  echo "[BTRS] Route this message. Classify and dispatch. Read skills/btrs/SKILL.md Step 1."
fi
