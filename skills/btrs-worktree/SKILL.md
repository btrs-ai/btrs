---
name: btrs-worktree
description: Create isolated git worktrees for feature work. Use when starting implementation that needs isolation from the current workspace.
disable-model-invocation: true
allowed-tools: Read, Write, Bash(git *), Bash(npm *), Bash(npx *), Bash(pip *), Bash(cargo *), Bash(go *), Bash(ls *)
argument-hint: <branch-name or feature description>
---

# /btrs-worktree

Create isolated git worktrees for feature work. Worktrees share the same repository but provide independent working directories, allowing parallel work on multiple branches without switching.

**Core principle:** Systematic setup + safety verification + baseline capture = reliable isolation.

**Announce at start:** "I'm using the btrs-worktree skill to set up an isolated workspace."

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
3. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

### Step 1: Determine branch name

1. If the argument looks like a branch name (e.g., `feature/auth`, `fix/login-bug`), use it directly.
2. If the argument is a feature description, derive a kebab-case branch name from it.
3. Validate the branch name does not already exist: `git branch --list {branch-name}`.

### Step 2: Safety verification

**MUST verify `btrs-worktrees/` is ignored before creating any worktree:**

```bash
git check-ignore -q btrs-worktrees 2>/dev/null
```

**If NOT ignored:**

Fix immediately -- do not proceed without this:

1. Add `btrs-worktrees/` to `.gitignore`
2. Stage and commit the change:

```bash
git add .gitignore
git commit -m "Add btrs-worktrees/ to .gitignore"
```

3. Proceed with worktree creation

**Why critical:** Prevents accidentally committing worktree contents to the repository.

### Step 3: Detect project info

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
root=$(git rev-parse --show-toplevel)
```

### Step 4: Create worktree

```bash
git worktree add btrs-worktrees/{branch-name} -b {branch-name}
cd btrs-worktrees/{branch-name}
```

### Step 5: Run project setup

Auto-detect and run the appropriate setup commands:

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

If no recognized project file is found, skip dependency installation.

### Step 6: Verify clean baseline

Run the project-appropriate test suite to confirm the worktree starts clean:

```bash
# Examples -- use the command that matches the project
npm test
cargo test
pytest
go test ./...
```

**If tests pass:** Record the results and proceed.

**If tests fail:** Report the failures clearly and ask the user whether to proceed anyway or investigate first. Do NOT silently continue.

### Step 7: Save baseline results

Persist baseline test output for regression comparison by `btrs-sanity-check`:

```bash
mkdir -p btrs/evidence/verification
```

Write the baseline file to `btrs/evidence/verification/baseline-{branch-name}-{YYYY-MM-DD}.md` with the following format:

```markdown
# Baseline: {branch-name}

- **Date:** {YYYY-MM-DD}
- **Worktree:** btrs-worktrees/{branch-name}
- **Project:** {project}
- **Test command:** {command used}
- **Result:** PASS | FAIL
- **Test count:** {N} passed, {N} failed, {N} skipped
- **Notes:** {any relevant context}

## Raw output

\`\`\`
{truncated test output -- first and last 50 lines if long}
\`\`\`
```

### Step 8: Report

```
Worktree ready at {full-path}
Branch: {branch-name}
Tests: {N} passed, {N} failed
Baseline saved: btrs/evidence/verification/baseline-{branch-name}-{date}.md
Ready to implement.
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| `btrs-worktrees/` exists | Use it (verify ignored) |
| `btrs-worktrees/` does not exist | Create it (verify ignored first) |
| Directory not in `.gitignore` | Add to `.gitignore` + commit immediately |
| Tests pass during baseline | Save baseline, report ready |
| Tests fail during baseline | Report failures + ask user |
| No package.json / Cargo.toml / etc. | Skip dependency install |
| Branch name already exists | Report conflict, ask user for alternative |

## Anti-Patterns

### Skipping ignore verification

- **Problem:** Worktree contents get tracked, pollute git status, risk committing generated files
- **Fix:** Always run `git check-ignore` before creating a project-local worktree

### Skipping baseline tests

- **Problem:** Cannot distinguish new bugs from pre-existing issues during development
- **Fix:** Always run the test suite and save baseline results

### Proceeding silently with failing tests

- **Problem:** Masked failures lead to false confidence and wasted debugging later
- **Fix:** Report failures explicitly, get user permission before continuing

### Hardcoding setup commands

- **Problem:** Breaks on projects using different tools or package managers
- **Fix:** Auto-detect from project files (package.json, Cargo.toml, etc.)

### Not saving baseline evidence

- **Problem:** `btrs-sanity-check` cannot compare against a known-good state for regression detection
- **Fix:** Always write baseline results to `btrs/evidence/verification/`

## Red Flags

**Never:**

- Create a worktree without verifying `btrs-worktrees/` is in `.gitignore`
- Skip baseline test verification
- Proceed with failing tests without explicit user approval
- Assume the project setup command -- always auto-detect
- Forget to save baseline evidence

**Always:**

- Verify the directory is ignored before creating worktrees
- Auto-detect and run project setup
- Run the test suite for a clean baseline
- Save baseline results for regression comparison
- Report worktree location, branch name, and test counts

## Integration

**Called by:**

- **btrs-brainstorm** -- when design is approved and implementation follows
- **btrs-execute** -- before executing any implementation tasks
- Any skill needing an isolated workspace

**Pairs with:**

- **btrs-finish** -- for cleanup, merge, and worktree removal after work is complete
