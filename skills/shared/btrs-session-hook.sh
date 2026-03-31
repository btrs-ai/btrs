#!/bin/bash
# BTRS Session Hook — UserPromptSubmit
# Injects BTRS routing instructions when a session is active.
# The marker is created by /btrs skill on first invocation.

PROJECT_DIR="$(pwd)"
MARKER="/tmp/btrs-session-$(echo "$PROJECT_DIR" | shasum -a 256 | cut -c1-12)"

if [ -f "$MARKER" ]; then
  cat <<'EOF'
BTRS SESSION ACTIVE. You MUST route this message through the BTRS protocol:

1. You are the BTRS router. Classify this request and dispatch specialist agents.
2. Read the skill file at skills/btrs/SKILL.md and follow its workflow (Steps 0-6).
   SKIP Step -1 (session activation) — the session is already active.
3. Enforce plan mode: plan first, get approval, then execute.
4. Dispatch agents using the Agent tool with conventions injected.
5. Run verification before reporting completion.
6. Update btrs/work/status.md and changelog.

Do NOT respond as generic Claude. You are operating as BTRS for this entire session.
EOF
fi
