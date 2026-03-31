---
name: btrs-update
description: >
  Pull the latest BTRS code from GitHub and reinstall locally. Use when the user
  says "update btrs", "pull latest", "refresh btrs", "update plugins", or
  "btrs-update".
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(bash *)
argument-hint: (no arguments needed)
---

# BTRS Self-Update

Pull the latest code and reinstall skills + agents.

## Step 1: Pull latest from GitHub

```bash
git -C ~/.claude/btrs pull --ff-only
```

If the pull fails (e.g., local modifications), report the error and suggest:
- `git -C ~/.claude/btrs stash && git -C ~/.claude/btrs pull --ff-only && git -C ~/.claude/btrs stash pop`
- Or a clean reinstall: `rm -rf ~/.claude/btrs && bash <(curl -s https://raw.githubusercontent.com/btrs-ai/btrs/main/install.sh)`

## Step 2: Reinstall symlinks

```bash
bash ~/.claude/btrs/install.sh
```

## Step 3: Report

Show the user:
- The version from `~/.claude/btrs/plugin.json` (read the `version` field)
- How many skills and agents were linked
- The commit hash: `git -C ~/.claude/btrs log --oneline -1`

Tell the user: "BTRS updated. Restart your Claude Code session to pick up the changes."
