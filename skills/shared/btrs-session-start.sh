#!/bin/bash
# BTRS Session Start Hook — cleans stale session markers.
# Each new Claude Code session starts fresh. User re-activates with /btrs.

PROJECT_DIR="$(pwd)"
MARKER="/tmp/btrs-session-$(echo "$PROJECT_DIR" | shasum -a 256 | cut -c1-12)"
rm -f "$MARKER" 2>/dev/null
