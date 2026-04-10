#!/usr/bin/env bash
set -euo pipefail

# BTRS v3 — Installer
# Clones the toolkit to ~/.claude/btrs and symlinks into ~/.claude/

CLAUDE_DIR="$HOME/.claude"
TOOLKIT_DIR="$CLAUDE_DIR/btrs"
SKILLS_DIR="$CLAUDE_DIR/skills"
AGENTS_DIR="$CLAUDE_DIR/agents"
REPO_URL="https://github.com/btrs-ai/btrs.git"

# Tier 1 agents (always loaded)
TIER1_AGENTS=(
  btrs-boss
  btrs-architect
  btrs-api-engineer
  btrs-web-engineer
  btrs-mobile-engineer
  btrs-ui-engineer
  btrs-database-engineer
  btrs-qa-test-engineering
  btrs-code-security
  btrs-devops
  btrs-research
  btrs-documentation
)

# v3 skills (tiered commands)
V3_SKILLS=(
  btrs
  build
  fix
  review
  research
  dispatch
)

echo ""
echo "  BTRS v3 — Installing"
echo "  12 specialist agents, 6 commands: /btrs /build /fix /review /research /dispatch"
echo ""

# Clone or update the toolkit
if [ -d "$TOOLKIT_DIR/.git" ]; then
  echo "Updating existing install..."
  git -C "$TOOLKIT_DIR" pull --ff-only 2>/dev/null || echo "  Could not pull — using existing version"
elif [ -d "$TOOLKIT_DIR" ]; then
  echo "ERROR: $TOOLKIT_DIR exists but is not a git repo. Remove it first."
  exit 1
else
  echo "Cloning to $TOOLKIT_DIR..."
  git clone "$REPO_URL" "$TOOLKIT_DIR"
fi

echo ""

# Create directories
mkdir -p "$SKILLS_DIR"
mkdir -p "$AGENTS_DIR"

# Clean up old v2 skill symlinks
echo "Cleaning old skill symlinks..."
for old_link in "$SKILLS_DIR"/btrs-*/; do
  link_name="$(basename "$old_link")"
  target="$SKILLS_DIR/$link_name"
  if [ -L "$target" ]; then
    rm "$target"
    echo "  Removed old symlink: $link_name"
  fi
done

# Symlink v3 skills
SKILL_COUNT=0
for skill_name in "${V3_SKILLS[@]}"; do
  skill_dir="$TOOLKIT_DIR/skills/$skill_name"
  target="$SKILLS_DIR/$skill_name"
  if [ -L "$target" ]; then
    rm "$target"
  fi
  if [ -d "$target" ] && [ ! -L "$target" ]; then
    echo "  SKIP $skill_name (directory exists, not a symlink — remove manually)"
    continue
  fi
  ln -s "$skill_dir" "$target"
  SKILL_COUNT=$((SKILL_COUNT + 1))
done
echo "Skills:     $SKILL_COUNT linked"

# Symlink shared references
SHARED_TARGET="$SKILLS_DIR/btrs-shared"
if [ -L "$SHARED_TARGET" ]; then
  rm "$SHARED_TARGET"
fi
if [ ! -d "$SHARED_TARGET" ]; then
  ln -s "$TOOLKIT_DIR/skills/shared" "$SHARED_TARGET"
  echo "Shared:     linked"
else
  echo "Shared:     SKIP (directory exists, not a symlink)"
fi

# Clean up old v2 agent symlinks
echo "Cleaning old agent symlinks..."
for old_link in "$AGENTS_DIR"/btrs-*/; do
  link_name="$(basename "$old_link")"
  target="$AGENTS_DIR/$link_name"
  if [ -L "$target" ]; then
    rm "$target"
  fi
done

# Symlink Tier 1 agents only
AGENT_COUNT=0
for agent_name in "${TIER1_AGENTS[@]}"; do
  agent_dir="$TOOLKIT_DIR/agents/$agent_name"
  target="$AGENTS_DIR/$agent_name"
  if [ -L "$target" ]; then
    rm "$target"
  fi
  if [ -d "$target" ] && [ ! -L "$target" ]; then
    echo "  SKIP $agent_name (directory exists, not a symlink — remove manually)"
    continue
  fi
  if [ -d "$agent_dir" ]; then
    ln -s "$agent_dir" "$target"
    AGENT_COUNT=$((AGENT_COUNT + 1))
  else
    echo "  WARN $agent_name directory not found at $agent_dir"
  fi
done
echo "Agents:     $AGENT_COUNT linked (Tier 1)"
echo "            Tier 2 agents available via /dispatch"

echo ""
echo "Done! Start any conversation with /btrs to get going."
echo "Commands: /btrs /build /fix /review /research /dispatch"
echo "To update later: ~/.claude/btrs/install.sh"
echo ""
