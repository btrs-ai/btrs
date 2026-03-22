#!/usr/bin/env bash
set -euo pipefail

# BTRS Agents — Uninstaller
# Removes all BTRS symlinks from ~/.claude/ and optionally the toolkit directory

CLAUDE_DIR="$HOME/.claude"
TOOLKIT_DIR="$CLAUDE_DIR/btrs"
SKILLS_DIR="$CLAUDE_DIR/skills"
AGENTS_DIR="$CLAUDE_DIR/agents"

echo ""
echo "  BTRS Agents — Uninstalling"
echo ""

# Remove skill symlinks
SKILL_COUNT=0
for link in "$SKILLS_DIR"/btrs*/; do
  link="${link%/}"
  if [ -L "$link" ]; then
    rm "$link"
    SKILL_COUNT=$((SKILL_COUNT + 1))
  fi
done
# Remove shared symlink
if [ -L "$SKILLS_DIR/btrs-shared" ]; then
  rm "$SKILLS_DIR/btrs-shared"
  SKILL_COUNT=$((SKILL_COUNT + 1))
fi
echo "Skills:     $SKILL_COUNT removed"

# Remove agent symlinks
AGENT_COUNT=0
for link in "$AGENTS_DIR"/btrs-*/; do
  link="${link%/}"
  if [ -L "$link" ]; then
    rm "$link"
    AGENT_COUNT=$((AGENT_COUNT + 1))
  fi
done
echo "Agents:     $AGENT_COUNT removed"

# Ask about toolkit directory
echo ""
if [ -d "$TOOLKIT_DIR" ]; then
  read -p "Remove toolkit directory ($TOOLKIT_DIR)? [y/N] " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$TOOLKIT_DIR"
    echo "Toolkit:    removed"
  else
    echo "Toolkit:    kept (you can remove manually later)"
  fi
fi

echo ""
echo "BTRS Agents uninstalled."
echo ""
