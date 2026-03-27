---
name: btrs-finish
description: Complete a development branch — merge, PR, keep, or discard. Use when implementation is complete and all tests pass.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git *), Bash(gh *)
argument-hint: [branch name]
---

# /btrs-finish

Complete a development branch. Verify tests, present options, execute choice, clean up.

**Core principle:** Sanity check → Verify tests → Present options → Execute choice → Clean up → Update status.

**Announce at start:** "I'm using the btrs-finish skill to complete this branch."

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `skills/shared/discipline-protocol.md` for the verification Iron Law.
3. Read `skills/shared/workflow-protocol.md` for status display requirements.

### Step 1: Sanity check gate

Before anything else, check for a sanity check report:

```bash
# Look for sanity check evidence for this branch
ls btrs/evidence/verification/sanity-check-{branch}-*.md 2>/dev/null
```

**If no report exists:**
```
REFUSED: No sanity check report found for branch '{branch}'.

Run /btrs-sanity-check first. No branch finishes without a clean sanity check.
```
Stop. Do not proceed.

**If report exists with BLOCKED status:**
```
REFUSED: Sanity check for branch '{branch}' has BLOCKED status.

Unresolved findings:
{list critical findings from the report}

Fix the issues and re-run /btrs-sanity-check before attempting btrs-finish.
```
Stop. Do not proceed.

**If report exists with CLEAN or HAS_FINDINGS (warnings only, no critical):**
Continue to Step 2.

Read the most recent report to confirm status. Parse the `Overall status` line. Only CLEAN and HAS_FINDINGS allow proceeding.

### Step 2: Verify tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Do not proceed to Step 3.

**If tests pass:** Continue to Step 3.

### Step 3: Determine base branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main — is that correct?"

### Step 4: Present options

Present exactly these 4 options:

```
Implementation complete. What would you like to do?

1. Merge back to {base-branch} locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Do not add explanation** — keep options concise.

### Step 5: Execute choice

#### Option 1: Merge locally

```bash
# Switch to base branch
git checkout {base-branch}

# Pull latest
git pull

# Merge feature branch
git merge {feature-branch}

# Verify tests on merged result
{test command}

# If tests pass
git branch -d {feature-branch}
```

Then: Cleanup worktree (Step 6), Update status (Step 7).

#### Option 2: Push and create PR

```bash
# Push branch
git push -u origin {feature-branch}

# Create PR
gh pr create --title "{title}" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

Then: Cleanup worktree (Step 6), Update status (Step 7).

#### Option 3: Keep as-is

Report: "Keeping branch {name}. Worktree preserved at {path}."

**Do not cleanup worktree.** Then: Update status (Step 7).

#### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch {name}
- All commits: {commit-list}
- Worktree at {path}

Type 'discard' to confirm.
```

Wait for exact confirmation. Do not accept abbreviations or variations.

If confirmed:
```bash
git checkout {base-branch}
git branch -D {feature-branch}
```

Then: Cleanup worktree (Step 6), Update status (Step 7).

### Step 6: Cleanup worktree

**For Options 1, 2, 4:**

Check if in worktree:
```bash
git worktree list | grep {feature-branch}
```

If yes:
```bash
git worktree remove btrs-worktrees/{feature-branch}
```

**For Option 3:** Keep worktree. Do not remove.

### Step 7: Update status

Update `btrs/work/status.md` based on the chosen option:

- **Option 1 (Merge):** Move branch entry to "Recently Completed" with date and "merged locally".
- **Option 2 (PR):** Move branch entry to "Recently Completed" with date and "PR created".
- **Option 3 (Keep):** Keep in "Current" but add note "branch kept, not merged".
- **Option 4 (Discard):** Remove the branch entry from status entirely.

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch | Status Update |
|--------|-------|------|---------------|----------------|---------------|
| 1. Merge locally | yes | - | - | yes | Recently Completed |
| 2. Create PR | - | yes | yes | - | Recently Completed |
| 3. Keep as-is | - | - | yes | - | Current (noted) |
| 4. Discard | - | - | - | yes (force) | Removed |

## Red Flags

**Never:**
- Proceed without a passing sanity check
- Proceed with failing tests
- Merge without verifying tests on result
- Delete work without typed "discard" confirmation
- Force-push without explicit request
- Skip the sanity check gate for any reason

**Always:**
- Check for sanity check report before anything else
- Verify tests before offering options
- Present exactly 4 options
- Get typed confirmation for Option 4
- Clean up worktree for Options 1 and 4 only
- Update `btrs/work/status.md` after every option

## Integration

**Called by:**
- **btrs-execute** (after all tasks complete)

**Pairs with:**
- **btrs-sanity-check** — Must run before this skill. This skill enforces the gate.
- **btrs-worktree** — Cleans up worktree created by that skill.

## Anti-patterns

- **Do not skip the sanity check gate.** The gate exists because developers routinely skip final verification. No exceptions, no "it's a small change" overrides.
- **Do not proceed with BLOCKED status.** If the sanity check found critical issues, they must be fixed first. Do not offer to "proceed anyway."
- **Do not add extra options beyond the 4.** The structured options prevent ambiguity. Do not add "5. Squash merge" or other variants.
- **Do not auto-select an option.** Always present the 4 options and wait for the user to choose.
- **Do not skip test verification because "sanity check already ran tests."** Tests must pass at the moment of finishing, not at some earlier point.
- **Do not remove the worktree for Option 2 (PR).** The branch needs to exist on remote and the user may need the worktree for PR review changes.
- **Do not silently skip the status update.** If `btrs/work/status.md` does not exist, note that to the user rather than silently skipping.
