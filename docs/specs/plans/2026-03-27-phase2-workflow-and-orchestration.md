# Phase 2: Workflow & Orchestration — Implementation Plan

> **For agentic workers:** Dispatch specialist agents per task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add workflow skills (worktree, finish, brainstorm, execute) and upgrade the router with session awareness, protocol injection, and automatic chaining.

**Architecture:** New skills integrate with the Phase 1 protocol system. The router becomes session-aware via `btrs/work/status.md`.

**Tech Stack:** Markdown skill definition files. No runtime code.

**Design Spec:** [2026-03-27-btrs-superpowers-merge-design.md](../2026-03-27-btrs-superpowers-merge-design.md)

---

## File Structure

### Files to Create
```
skills/btrs-worktree/SKILL.md                      — Git worktree management
skills/btrs-finish/SKILL.md                        — Branch completion (merge/PR/keep/discard)
skills/btrs-brainstorm/SKILL.md                    — Collaborative design → spec creation
skills/btrs-execute/SKILL.md                       — Subagent-driven plan execution
skills/btrs-execute/implementer-prompt.md          — Implementer dispatch template
skills/btrs-execute/spec-reviewer-prompt.md        — Spec compliance review template
skills/btrs-execute/code-quality-reviewer-prompt.md — Code quality review template
```

### Files to Modify
```
skills/btrs/SKILL.md                               — Router upgrade
skills/btrs-plan/SKILL.md                          — TDD-compatible task output
skills/btrs-init/SKILL.md                          — Three-tier migration + structure updates
```

---

## Task 1: Create `btrs-worktree` skill

**Files:** Create `skills/btrs-worktree/SKILL.md`

- [ ] **Step 1:** Read Superpowers source at `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.6/skills/using-git-worktrees/SKILL.md`
- [ ] **Step 2:** Create directory and write adapted skill with BTRS frontmatter, Step 0 (read config, discipline-protocol, workflow-protocol), and these adaptations:
  - Worktree directory: `btrs-worktrees/` at project root (simpler than Superpowers' multi-option approach since we're Claude Code first)
  - Safety verification: check `.gitignore` covers `btrs-worktrees/`, add if not
  - Creation: `git worktree add btrs-worktrees/{branch-name} -b {branch-name}`
  - Auto-detect project setup (npm install, cargo build, pip install, etc.)
  - Run test suite for baseline capture — save results to `btrs/evidence/verification/baseline-{branch}-{date}.md`
  - Report: location, branch name, baseline test count
  - Replace all Superpowers skill refs with btrs equivalents (btrs-brainstorm, btrs-execute, btrs-finish)
  - Anti-patterns section
- [ ] **Step 3:** Commit

---

## Task 2: Create `btrs-finish` skill

**Files:** Create `skills/btrs-finish/SKILL.md`

- [ ] **Step 1:** Read Superpowers source at `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.6/skills/finishing-a-development-branch/SKILL.md`
- [ ] **Step 2:** Create directory and write adapted skill:
  - BTRS frontmatter, Step 0
  - **Gate:** Refuses to proceed if `btrs-sanity-check` hasn't run or has unresolved findings. Check for `btrs/evidence/verification/sanity-check-{branch}-*.md`
  - Step 1: Verify tests pass (hard stop if failing)
  - Step 2: Determine base branch
  - Step 3: Present exactly 4 options (merge locally / push + PR / keep branch / discard)
  - Step 4: Execute chosen option (preserve Superpowers' exact bash commands)
  - Step 5: Cleanup worktree (Options 1,4 only; keep for 2,3)
  - Step 6: Update `btrs/work/status.md` — move to recently completed or clear
  - Option 4 (Discard) requires typing "discard" to confirm
  - Replace Superpowers skill refs with btrs equivalents
  - Anti-patterns section
- [ ] **Step 3:** Commit

---

## Task 3: Create `btrs-brainstorm` skill

**Files:** Create `skills/btrs-brainstorm/SKILL.md`

- [ ] **Step 1:** Read Superpowers source at `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.6/skills/brainstorming/SKILL.md`
- [ ] **Step 2:** Create directory and write rewritten skill (deeper BTRS integration):
  - BTRS frontmatter, Step 0 (read config, conventions, discipline-protocol, workflow-protocol)
  - HARD-GATE: No implementation before design approved (preserve from Superpowers)
  - Load existing conventions from `btrs/knowledge/conventions/` before asking questions
  - Check existing specs in `btrs/work/specs/` for overlap
  - Follow Superpowers process: explore context → clarifying questions (one at a time, multiple choice preferred) → 2-3 approaches with trade-offs → sectioned design presentation
  - Write spec to `btrs/work/specs/SPEC-NNN-{slug}.md` using BTRS spec format (read `skills/shared/spec-format.md`)
  - Spec self-review (placeholder scan, consistency, scope, ambiguity)
  - User review gate
  - Terminal state: invoke `btrs-plan` (the ONLY next step)
  - **Omit** visual companion (token-heavy, experimental — can add in Phase 3)
  - Anti-patterns section
- [ ] **Step 3:** Commit

---

## Task 4: Create `btrs-execute` skill + prompt templates

**Files:** Create `skills/btrs-execute/SKILL.md`, `implementer-prompt.md`, `spec-reviewer-prompt.md`, `code-quality-reviewer-prompt.md`

- [ ] **Step 1:** Read all 4 Superpowers source files (SKILL.md + 3 prompt templates)
- [ ] **Step 2:** Create directory and write the execution skill:
  - BTRS frontmatter, Step 0
  - Core principle: Fresh subagent per task + two-stage review
  - Process: Read plan → extract tasks → create TaskCreate items → per-task loop (dispatch implementer → spec review → quality review → mark complete) → btrs-sanity-check → btrs-finish
  - Model selection guidance (cheap for mechanical, standard for integration, capable for review)
  - Implementer status handling (DONE, DONE_WITH_CONCERNS, NEEDS_CONTEXT, BLOCKED)
  - Replace Superpowers skill refs: `superpowers:test-driven-development` → `btrs-tdd`, `superpowers:finishing-a-development-branch` → `btrs-finish`, `superpowers:using-git-worktrees` → `btrs-worktree`
  - For code quality review: use BTRS agent `btrs-qa-test-engineering` instead of Superpowers' code-reviewer (adapt the prompt to dispatch this agent)
  - Red flags section (never parallel implementers, never skip reviews, etc.)
  - Anti-patterns section
- [ ] **Step 3:** Write 3 prompt templates adapted for BTRS:
  - `implementer-prompt.md` — preserve structure, update skill refs, add `btrs/evidence/` output paths
  - `spec-reviewer-prompt.md` — preserve adversarial stance, update refs
  - `code-quality-reviewer-prompt.md` — replace `superpowers:code-reviewer` with btrs-qa-test-engineering dispatch, add 4 BTRS-specific checks
- [ ] **Step 4:** Commit

---

## Task 5: Upgrade `btrs` router with session awareness and chaining

**Files:** Modify `skills/btrs/SKILL.md`

- [ ] **Step 1:** Read current router in full
- [ ] **Step 2:** Add session awareness to Step 0:
  - Read `btrs/work/status.md` if it exists
  - If active work exists and request relates to it → continue from current state
  - If active work exists but request is unrelated → ask: pause or finish first?
  - If bare `/btrs` with no request → show status, ask what to work on
  - If no active work → proceed to classification
- [ ] **Step 3:** Enhance classification (Step 1):
  - Add "debug" bucket → routes to `btrs-debug`
  - Add "brainstorm/design" bucket → routes to `btrs-brainstorm`
  - Existing buckets: quick answer, single-agent, multi-agent, unclear
- [ ] **Step 4:** Add protocol injection to dispatch (Step 4):
  - Inject discipline-protocol.md content (relevant sections only based on agent type)
  - Inject workflow-protocol.md content
  - Inject relevant context from status.md
- [ ] **Step 5:** Add automatic chaining logic:
  - Implementation requests → worktree before dispatch, TDD in agent context, verify after
  - Multi-agent requests → plan first, then btrs-execute
  - After all agents complete → btrs-sanity-check → btrs-finish
- [ ] **Step 6:** Add state management:
  - After significant transitions, update btrs/work/status.md
- [ ] **Step 7:** Commit

---

## Task 6: Upgrade `btrs-plan` for TDD-compatible output

**Files:** Modify `skills/btrs-plan/SKILL.md`

- [ ] **Step 1:** Read current btrs-plan in full
- [ ] **Step 2:** Update task output format — each task step should follow TDD cycle:
  - Write failing test
  - Run to verify failure
  - Write minimal implementation
  - Run tests to verify pass
  - Refactor if needed
  - Commit
- [ ] **Step 3:** Add 2-5 minute granularity requirement per step
- [ ] **Step 4:** Add "No Placeholders" rule (forbidden: TBD, TODO, "Add appropriate error handling", "Similar to Task N")
- [ ] **Step 5:** Add execution handoff — after plan approval, offer btrs-execute (subagent) or inline execution
- [ ] **Step 6:** Commit

---

## Task 7: Upgrade `btrs-init` with migration support

**Files:** Modify `skills/btrs-init/SKILL.md`

- [ ] **Step 1:** Read current btrs-init in full
- [ ] **Step 2:** Add migration detection — check for old `.btrs/` directory or `AI/memory/` directory
- [ ] **Step 3:** Add migration logic:
  - Detect old structure, map files to new three-tier locations
  - Move files (not copy) to preserve git history where possible
  - Update internal wiki links
  - Report what was migrated
- [ ] **Step 4:** Add version field to `btrs/knowledge/conventions/config.json` output
- [ ] **Step 5:** Ensure Step 2 creates the full three-tier structure (knowledge/, work/, evidence/ with all subdirectories)
- [ ] **Step 6:** Add `btrs/work/status.md` creation with initial template
- [ ] **Step 7:** Commit

---

## Task 8: Create initial `btrs/work/status.md` template

This is a template file that btrs-init writes when initializing a project.

**Files:** Modify `skills/btrs-init/SKILL.md` (add template in Step 2)

- [ ] **Step 1:** Add status.md template to the btrs-init Step 2 vault creation:

```markdown
---
title: Active Work Status
updated: YYYY-MM-DD
---

# Active Work

## Current
_No active work._

## Blocked
_Nothing blocked._

## Recently Completed
_No recent completions._
```

- [ ] **Step 2:** Commit

Note: Tasks 7 and 8 both modify btrs-init, so combine them into a single agent dispatch.
