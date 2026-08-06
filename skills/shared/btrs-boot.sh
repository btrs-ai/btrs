#!/bin/bash
# btrs boot — single round trip for everything /btrs needs to start routing.
#
# Replaces the serial chain of: touch session marker -> Glob project-map.md
# -> Read project-map.md -> Read config.json -> Read status.md. That was 4-5
# tool round trips, each re-sending the full context window before any work
# began.
#
# Usage: btrs-boot.sh "$ARGUMENTS"

set -uo pipefail

ARGS="${1:-}"
PROJECT_DIR="$(pwd)"
HASH="$(echo "$PROJECT_DIR" | shasum -a 256 | cut -c1-12)"

# ── Session marker (was Step -1) ─────────────────────────────────────────────
touch "/tmp/btrs-session-$HASH"
rm -f "/tmp/btrs-routed-$HASH"

# ── Scope check ──────────────────────────────────────────────────────────────
SCOPE_FILE="$HOME/.claude/btrs/scope.conf"
if [ -f "$SCOPE_FILE" ]; then
  # shellcheck source=/dev/null
  source "$SCOPE_FILE"
fi
BTRS_SCOPE="${BTRS_SCOPE:-$HOME/PERSONAL}"
BTRS_SCOPE="${BTRS_SCOPE/#\~/$HOME}"

echo "=== BTRS BOOT ==="
echo "pwd: $PROJECT_DIR"
if [[ "$PROJECT_DIR" == "$BTRS_SCOPE" || "$PROJECT_DIR" == "$BTRS_SCOPE"/* ]]; then
  echo "scope: IN"
else
  echo "scope: OUT (btrs auto-activates under $BTRS_SCOPE — continuing anyway)"
fi
echo "session: activated"

# ── Init state ───────────────────────────────────────────────────────────────
if [ ! -f "btrs/project-map.md" ]; then
  echo "init: MISSING (run first-time init — see btrs-init/SKILL.md)"
  # Emit detection hints so init does not need its own round trips.
  echo ""
  echo "--- init hints ---"
  echo "dir: $(basename "$PROJECT_DIR")"
  for f in package.json pyproject.toml requirements.txt go.mod Cargo.toml \
           pom.xml build.gradle Gemfile composer.json CMakeLists.txt; do
    [ -f "$f" ] && echo "found: $f"
  done
  for f in tsconfig.json next.config.js vite.config.ts tailwind.config.js \
           docker-compose.yml Dockerfile .github/workflows; do
    [ -e "$f" ] && echo "found: $f"
  done
  [ -f "CLAUDE.md" ] && echo "found: CLAUDE.md" || echo "missing: CLAUDE.md"
  [ -d .git ] && echo "git: repo root" || echo "git: not a repo root"
  echo "src ext counts:"
  find . -maxdepth 3 -type f -name "*.*" \
       ! -path "./node_modules/*" ! -path "./.git/*" ! -path "./dist/*" \
       ! -path "./build/*" ! -path "./.venv/*" 2>/dev/null \
    | sed 's/.*\.//' \
    | grep -E '^(ts|tsx|js|jsx|py|go|rs|java|rb|php|swift|kt|c|cpp|h|hpp|sql|sh)$' \
    | sort | uniq -c | sort -rn | head -6
  echo "=== END BTRS BOOT ==="
  exit 0
fi
echo "init: READY"

# ── config.json ──────────────────────────────────────────────────────────────
if [ -f "btrs/config.json" ]; then
  echo ""
  echo "--- btrs/config.json ---"
  cat btrs/config.json
fi

# ── status.md — active work, always relevant for session awareness ───────────
if [ -f "btrs/status.md" ]; then
  echo ""
  echo "--- btrs/status.md ---"
  head -100 btrs/status.md
fi

# ── project-map.md (only when there is a task to route) ──────────────────────
if [ -n "$ARGS" ] && [ -f "btrs/project-map.md" ]; then
  echo ""
  echo "--- btrs/project-map.md ---"
  head -200 btrs/project-map.md
fi

# ── conventions/, decisions/, specs/ — INDEX ONLY, never full contents ───────
# These grow without bound in a mature project. Dumping them would cost more
# than everything else here combined. Emit an index; the routed skill Reads
# only what the request actually touches.
emit_index() {
  local dir="$1" label="$2"
  if [ -d "$dir" ]; then
    local files
    files="$(find "$dir" -maxdepth 1 -name "*.md" -size +0 2>/dev/null | sort)"
    if [ -n "$files" ]; then
      echo ""
      echo "--- $label index (READ ONLY WHAT THE REQUEST NEEDS) ---"
      while IFS= read -r f; do
        local title
        title="$(grep -m1 '^#' "$f" 2>/dev/null | sed 's/^#* *//' | cut -c1-80)"
        printf '%s  (%s chars)  %s\n' "$f" "$(wc -c < "$f" | tr -d ' ')" "${title:-untitled}"
      done <<< "$files"
    fi
  fi
}
emit_index "btrs/conventions" "btrs/conventions/"
emit_index "btrs/decisions"   "btrs/decisions/"
emit_index "btrs/specs"       "btrs/specs/"

echo ""
echo "Do not re-read anything printed above. Read indexed files only when the request needs them."
echo "=== END BTRS BOOT ==="
