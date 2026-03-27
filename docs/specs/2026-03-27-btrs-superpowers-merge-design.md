# BTRS + Superpowers Merge — Design Spec

**Date:** 2026-03-27
**Status:** Draft
**Goal:** Merge Superpowers' behavioral discipline into BTRS, creating a single self-contained plugin that combines BTRS's 24-agent orchestration with Superpowers' battle-tested enforcement patterns.

---

## Decisions

- **Platform:** Claude Code first. Cross-platform (Cursor, Copilot, Windsurf, Codex) is not a design constraint.
- **Superpowers relationship:** BTRS becomes a superset — replaces both plugins.
- **Enforcement style:** Hybrid — full Iron Law for discipline skills (TDD, verification, debugging, code review), lighter enforcement elsewhere.
- **Skill adaptation strategy:** Adapt Superpowers originals for Iron Law skills (preserve battle-tested language). Rewrite for workflow/orchestration skills (deeper BTRS integration needed).
- **Phased delivery:** Phase 1 (discipline + bug fixes) → Phase 2 (workflow + orchestration) → Phase 3 (polish + refinement).
- **Architecture:** Agent Protocol Upgrade — shared protocol files injected into every agent dispatch, agents self-enforce.
- **Output directory:** `btrs/` (no dot prefix, visible, Obsidian-browsable).
- **Agent memory model:** Agents are producers, not owners. Output goes to artifact tiers, not per-agent folders.
- **Link strategy:** Wiki links (`[[]]`) between `btrs/` documents. Standard markdown links with relative paths for source code references (works in both GitHub and Obsidian).

---

## Output Directory Structure

Three-tier `btrs/` directory replaces both the old `.btrs/` Obsidian vault and the `AI/memory/` system:

```
btrs/
├── knowledge/          ← Long-lived project truth (Obsidian graph)
│   ├── conventions/    ← Detected patterns, coding standards
│   ├── decisions/      ← ADRs, architecture choices
│   ├── code-map/       ← Component/utility/hook/constant/type/API registry
│   │   ├── components.md
│   │   ├── utilities.md
│   │   ├── hooks.md
│   │   ├── constants.md
│   │   ├── types.md
│   │   └── api.md
│   └── tech-debt/      ← Tracked debt items
│
├── work/               ← Active work artifacts (lifecycle-managed)
│   ├── specs/          ← Feature specs (draft → approved → implemented)
│   ├── plans/          ← Implementation plans (linked to specs)
│   ├── todos/          ← Task breakdowns (linked to plans)
│   ├── changelog/      ← Release notes, change records
│   └── status.md       ← Living document: active work, blocked items, recent completions
│
├── evidence/           ← Audit trail (append-only, prunable)
│   ├── reviews/        ← Code review reports
│   ├── verification/   ← Verification evidence logs
│   ├── debug/          ← Root cause investigations
│   └── sessions/       ← Agent activity summaries
│
└── .obsidian/          ← Obsidian config (graph, templates)
```

### Code-Map Registry (expanded)

| Registry File | What It Tracks |
|---------------|----------------|
| `components.md` | UI components (existing) |
| `utilities.md` | Utility/helper functions (expanded scope) |
| `hooks.md` | Custom hooks (existing) |
| `constants.md` | Shared constants, enums, config values (new) |
| `types.md` | Shared types, interfaces, schemas (new) |
| `api.md` | API client methods, endpoint definitions (new) |

Updated by `btrs-init` and refreshable via `btrs-init --refresh`.

### Session Awareness via `status.md`

The router reads `btrs/work/status.md` at the start of every session to provide continuity:

```markdown
# Active Work

## Current
- **Spec**: [User Dashboard](specs/SPEC-012-user-dashboard.md) — status: implementing
- **Plan**: [Dashboard Plan](plans/PLAN-012-user-dashboard.md) — tasks 1-3 done, task 4 in progress
- **Branch**: `feat/user-dashboard`
- **Worktree**: `btrs-worktrees/feat-user-dashboard/`

## Blocked
- [API Rate Limiting](specs/SPEC-010-rate-limiting.md) — waiting on vendor response

## Recently Completed
- [Auth Middleware](specs/SPEC-011-auth-middleware.md) — merged 2026-03-24
```

Only the router writes to `status.md`. Agents return results; the router updates status.

---

## New Shared Protocol Files

### `skills/shared/discipline-protocol.md`

Injected into every implementation agent dispatch. Contains:

**TDD Mandate:**
- No production code without a failing test first.
- If code was written before the test: delete it, start over.
- Red-green-refactor cycle for every change.

**Verification Mandate:**
- No completion claims without fresh verification evidence.
- Forbidden words in success claims: "should", "probably", "seems to", "I believe".
- Must run the actual command, read full output, check exit code.

**Debugging Mandate:**
- No fixes without root cause investigation first.
- One hypothesis, one variable at a time.
- If fix doesn't work after 3 attempts: stop, question the architecture.

**Dependency Justification:**
- Before adding any dependency, justify against three alternatives: (1) native/built-in API, (2) write it yourself in 5-20 lines, (3) a package already in the project.
- Dependency is the last resort, not the first.

**Duplication Prevention:**
- Before creating any new function, constant, type, or component: grep the codebase for existing implementations.
- Code-map is a starting point, not the complete picture.
- If something does 80% of what you need, extend it rather than duplicating.

**Performance Awareness:**
- Before writing a loop that touches a database, API, or collection: state the expected time complexity.
- If worse than O(n), justify why.

**Enforcement:** Full Iron Law for TDD, verification, debugging (rationalization tables, red flags, no exceptions). Standing rules for dependency, duplication, and performance (enforced but without adversarial language).

**Escape clause:** If the user explicitly requests skipping any discipline rule for a specific change, acknowledge and proceed. The user always takes precedence. The key word is *explicitly* — not by implication.

### `skills/shared/workflow-protocol.md`

Defines expected workflow order without being a rigid pipeline:

- **Worktree before implementation:** Create isolated branch/worktree before any code changes.
- **Plan before multi-step work:** No multi-file implementations without a plan.
- **Review after implementation:** Code review is required before branch completion.
- **Verify before complete:** Sanity check + verification must pass before finishing.
- **Status updates:** Every state transition updates `btrs/work/status.md`.

#### Status Display Protocol

Every skill and agent dispatch MUST provide live visibility into what is happening. This is not optional — silent execution erodes trust.

**Rule 1: Task checklist for every skill invocation.**
When any skill starts, it creates TaskCreate items for each major step. Tasks are updated to `in_progress` when starting and `completed` when done. The user sees real-time progress:

```
☑ Reading project conventions
☑ Checking btrs/work/status.md for active work
☐ Classifying request  ← (spinner: "Classifying request...")
☐ Dispatching btrs-web-engineer
☐ Running sanity check
☐ Verification
```

**Rule 2: Agent dispatch announcements.**
When the router dispatches any agent, it announces explicitly before dispatch:

```
Dispatching btrs-web-engineer to implement Dashboard analytics widget
  Context: React + TypeScript project, Zustand for state, Tailwind CSS
  Injected: TDD protocol, project conventions
  Working in: btrs-worktrees/feat-dashboard/
```

**Rule 3: Pass-by-pass status for multi-step checks.**
Skills with multiple internal passes (especially `btrs-sanity-check`) display each pass as a task item with its result:

```
Sanity Check:
  ☑ Regression — 47 tests passed, 0 new failures
  ☑ Leak & Resource — clean
  ☑ Dead Code — 1 unused import found (flagged)
  ☐ Debug Artifacts  ← (spinner)
  ☐ Behavioral Regression
  ☐ Dependency Health
  ☐ Dependency Justification
  ☐ Type Safety
  ☐ Duplication
  ☐ Performance
```

**Rule 4: Verification evidence display.**
Every verification claim must show the actual evidence inline — not just "passed":

```
Verification:
  Command: npm test
  Exit code: 0
  Result: 47 passed, 0 failed, 0 skipped
  ✓ Claim confirmed: "All tests pass"
```

**Rule 5: Workflow position indicator.**
For multi-step workflows, display the current position in the overall flow:

```
Workflow: brainstorm → plan → [worktree] → execute → sanity-check → finish
                               ^^^^^^^^^ you are here
```

**Implementation:** These rules are codified in the workflow protocol so every skill inherits them. Skills MUST create task items for their steps. Agent dispatches MUST be announced with context. Verifications MUST show evidence. No silent execution.

---

## New Skills (8)

### `btrs-tdd`

- **Source:** Adapted from Superpowers TDD skill (preserve Iron Law language).
- **Enforcement:** Full — rationalization tables, red flags, deletion mandate.
- **Core rule:** NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.
- **Cycle:** RED (write failing test, verify it fails for the right reason) → GREEN (simplest code to pass) → REFACTOR (clean up while green).
- **Integrated into:** Discipline protocol (injected into all implementation agents). Also callable directly via `/btrs tdd`.

### `btrs-debug`

- **Source:** Adapted from Superpowers systematic-debugging (preserve 4-phase structure).
- **Enforcement:** Full — no fixes without root cause.
- **Phases:** (1) Root Cause Investigation → (2) Pattern Analysis → (3) Hypothesis & Testing → (4) Implementation.
- **Architecture escape hatch:** If fix doesn't work after 3+ attempts, stop and discuss with user.
- **Callable via:** `/btrs debug <description>` or auto-triggered when router classifies request as a bug/failure.

### `btrs-brainstorm`

- **Source:** Rewritten for BTRS (integrates convention loading, writes specs to `btrs/work/specs/`).
- **Enforcement:** Light — process skill.
- **Flow:** Explore context → clarifying questions (one at a time) → 2-3 approaches with trade-offs → sectioned design presentation → write spec → self-review → user approval → transition to `btrs-plan`.
- **Terminal state:** Always transitions to `btrs-plan`. Never directly to implementation.

### `btrs-worktree`

- **Source:** Rewritten for BTRS (Claude Code only, simpler).
- **Enforcement:** Light.
- **Flow:** Create worktree with new branch → auto-detect and run project setup → run test suite for clean baseline → report location and test count.
- **Safety:** Verify `.gitignore` covers worktree directory. If not, add and commit immediately.
- **Baseline capture:** Record test results at worktree creation for later regression comparison in `btrs-sanity-check`.

### `btrs-finish`

- **Source:** Rewritten for BTRS.
- **Enforcement:** Light — structured choices.
- **Gate:** Refuses to proceed if `btrs-sanity-check` hasn't run or has unresolved findings.
- **Options:** (1) Merge back to base branch locally, (2) Push and create PR, (3) Keep branch as-is, (4) Discard — requires typing "discard" to confirm.
- **Cleanup:** Removes worktree for options 1, 2, 4. Keeps for option 3.
- **State:** Updates `btrs/work/status.md` — moves to recently completed or clears.

### `btrs-execute`

- **Source:** Rewritten for BTRS (uses BTRS agent registry for dispatch).
- **Enforcement:** Medium — review enforcement matters.
- **Flow per task:** Dispatch implementer agent → collect result → dispatch spec-compliance reviewer (independent, told "do not trust implementer's report") → if issues, implementer fixes → dispatch code-quality reviewer → if issues, implementer fixes → mark task complete.
- **Parallelism:** Router identifies independent tasks from plan dependency graph, dispatches in parallel batches.
- **After all tasks:** Trigger `btrs-sanity-check` → `btrs-finish`.
- **Note:** The two-stage review within `btrs-execute` is automatic and internal to plan execution. `btrs-request-review` (Phase 3) is a separate skill for standalone review requests outside of plan execution (e.g., reviewing a manual change before merge).

### `btrs-sanity-check`

- **Source:** New — combines and extends Superpowers' verification with comprehensive code quality analysis.
- **Enforcement:** Full Iron Law. No branch finishes without a clean sanity check.
- **10 passes over all changes since branch diverged:**

| # | Pass | What It Checks |
|---|------|---------------|
| 1 | Regression | Full test suite. Diff results against baseline from worktree creation. New failures = stop. |
| 2 | Leak & Resource | Unclosed connections, missing cleanup/dispose, event listeners without removal, missing unsubscribe, setInterval without clear. |
| 3 | Dead Code | Unreachable branches, unused imports/variables, functions defined but never called, commented-out code. |
| 4 | Debug Artifacts | console.log, debugger, TODO/FIXME introduced in this branch, hardcoded test values, `.only` on tests. |
| 5 | Behavioral Regression | For every changed file: could this change break existing behavior not covered by tests? Flag uncertainties. |
| 6 | Dependency Health | New packages: maintained? Known vulnerabilities? Duplicates existing dependency? |
| 7 | Dependency Justification | Usage ratio (1 function from 200-function library?). Native alternative? Trivial to implement yourself? Transitive bloat? |
| 8 | Type Safety | Run type checker. New `any` types, type assertions, `@ts-ignore` introduced? |
| 9 | Duplication | For every new function/constant/type/component: grep codebase for similar names, signatures, logic. Flag potential duplicates. |
| 10 | Performance | Nested loops over same collection, await in loops, N+1 queries, missing pagination, large objects when subset needed, expensive computations without memoization. |

### `btrs-receive-review`

- **Source:** Adapted from Superpowers (preserve anti-performative-agreement rules).
- **Enforcement:** Full.
- **Core rule:** Before implementing any review suggestion, verify it's technically correct for THIS codebase. Check: does it break existing functionality? Is there a reason the current implementation exists? Does it conflict with project conventions?
- **YAGNI check:** If reviewer suggests a feature, grep for actual usage first.
- **Forbidden responses:** "You're absolutely right!", "Great point!", "Let me implement that now" (before verification).

---

## Upgraded Skills (4)

### `btrs-verify` (upgrade)

Merge Superpowers' paranoid verification into existing skill:
- Add forbidden words list ("should", "probably", "seems to").
- Require fresh command output (not recalled from earlier in session).
- 5-step gate: Identify command → Run it → Read full output → Verify it confirms claim → Only then make the claim.
- Skip any step = "lying, not verifying."

### `btrs-plan` (upgrade)

Output TDD-compatible tasks:
- Each task step: write failing test → run to verify failure → write minimal code → run tests → refactor → commit.
- 2-5 minute granularity per step.
- No placeholders: "TBD", "TODO", "Add appropriate error handling" are forbidden.
- Mandatory header with goal, architecture, tech stack.

### `btrs-init` (upgrade)

- Create new three-tier `btrs/` structure.
- Expanded code-map registry (add constants.md, types.md, api.md).
- Migration mode: detect old `.btrs/` or `AI/memory/` structure, move files to new locations, update internal links.
- Version field in `btrs/knowledge/conventions/config.md` for future structural changes.

### `btrs` router (upgrade)

- **Session awareness:** Read `btrs/work/status.md` first. Present active work, ask to continue or start new.
- **Enhanced classification:** Add "debug" bucket that routes to `btrs-debug`.
- **Protocol injection:** Inject discipline-protocol.md (relevant sections only) and workflow-protocol.md into every agent dispatch alongside conventions.
- **Automatic chaining:** Worktree before implementation. TDD protocol in agent context. Verify + sanity-check before complete. Review after implementation.
- **State management:** Update `btrs/work/status.md` after every significant transition.
- **Token efficiency:** Only inject relevant discipline protocol sections per agent type (implementation agents get TDD + verification, research agents get neither).

---

## Deprecated Skill (1)

### `btrs-spec` (deprecated)

Functionality absorbed by `btrs-brainstorm` (spec creation) and `btrs-plan` (spec-to-plan transition). Kept for standalone spec CRUD operations. Marked with: "Prefer `btrs-brainstorm` for new specs."

---

## Agent Body Changes (all 24)

### Fix 1: Path Migration

All `AI/memory/agents/<name>/` references replaced with artifact-tier paths:

| Agent Action | Old Path | New Path |
|-------------|----------|----------|
| Task assignments | `AI/memory/agents/boss/active-tasks.json` | `btrs/work/todos/` |
| Architecture decisions | `AI/memory/agents/architect/decisions.json` | `btrs/knowledge/decisions/` |
| Test reports | `AI/memory/agents/qa/test-results.json` | `btrs/evidence/reviews/` |
| Research findings | `AI/memory/agents/research/findings.json` | `btrs/knowledge/decisions/` |
| Debug logs | N/A | `btrs/evidence/debug/` |
| Verification evidence | N/A | `btrs/evidence/verification/` |

### Fix 2: Remove Generic Code Examples

Replace ~350 lines of hardcoded patterns (axios, Zustand, React Router, etc.) in agent bodies with convention-reading directives:

```markdown
## Implementation Patterns
Read the project's detected conventions before writing any code:
- `btrs/knowledge/conventions/framework.md`
- `btrs/knowledge/conventions/libraries.md`
- `btrs/knowledge/conventions/patterns.md`

Follow existing project patterns. Do NOT use patterns from your training
data if they conflict with what the project actually uses.
```

### Fix 3: Protocol References

Add to every agent's boilerplate:

```markdown
## Discipline Protocol
Read and follow `skills/shared/discipline-protocol.md` for all implementation work.

## Workflow Protocol
Read and follow `skills/shared/workflow-protocol.md` for task lifecycle requirements.
```

---

## Removals

| Item | Replacement |
|------|-------------|
| `AI/memory/` directory | `btrs/` three-tier structure. Migrate research finding to `btrs/knowledge/decisions/`. |
| Per-agent memory paths in AGENT.md | Artifact-tier writes. |
| Generic code examples in agent bodies | Convention-reading directives. |
| Cross-platform adaptation sections in AGENTS.md | Trimmed. Claude Code first. |

---

## Agent Communication Model

Agents never communicate peer-to-peer. The router is always the hub:

1. Router dispatches Agent A with context + protocols.
2. Agent A returns result.
3. Router extracts relevant context for Agent B using `btrs-handoff` logic.
4. Router dispatches Agent B with translated context + protocols.
5. Router updates `btrs/work/status.md` after each completion.

For plans with independent tasks, `btrs-execute` dispatches parallel batches via Claude Code's Agent tool. The router identifies parallelizable tasks from the plan's dependency graph.

---

## Technical Risks & Mitigations

### Token Budget Pressure
**Risk:** ~2000-3300 additional tokens per agent dispatch from protocol injection.
**Mitigation:** Modular protocol injection — only inject relevant sections per agent type. Implementation agents get TDD + verification. Research agents get neither.

### `status.md` Conflicts
**Risk:** Parallel agents writing to `status.md` simultaneously.
**Mitigation:** Only the router writes to `status.md`. Single writer, no conflicts.

### Vault Structure Migration
**Risk:** Existing projects using old `.btrs/` or `AI/memory/` structure would break.
**Mitigation:** `btrs-init` detects old structure and migrates. Version field in config for future changes.

### Worktree + Subagent Paths
**Risk:** Subagents working in main repo instead of worktree.
**Mitigation:** Router passes worktree absolute path in agent prompt. Explicit instruction: "You are working in `/path/to/worktree/`, NOT the main repository."

### Iron Law vs. User Intent
**Risk:** User says "skip tests" but TDD Iron Law says "never."
**Mitigation:** User instructions always take precedence. Discipline protocol includes explicit escape clause requiring deliberate opt-out.

### Plugin Size
**Risk:** ~10 new skill files increases footprint.
**Mitigation:** Skills are loaded on-demand. Router complexity lives in protocol files it reads, not inline.

---

## Phase Plan

### Phase 1 — Discipline & Bug Fixes (highest impact)

1. Fix `AI/memory/` → `btrs/` path inconsistency across all 24 agent bodies.
2. Create `skills/shared/discipline-protocol.md`.
3. Create `skills/shared/workflow-protocol.md`.
4. New skill: `btrs-tdd`.
5. New skill: `btrs-debug`.
6. Upgrade `btrs-verify` with Iron Law enforcement.
7. New skill: `btrs-sanity-check` (10-pass).
8. Update all existing skills' Step 0 to read new protocol files.
9. Fix agent bodies: remove generic code examples, add protocol references.
10. Expand code-map registry (add constants.md, types.md, api.md).

### Phase 2 — Workflow & Orchestration

1. New skill: `btrs-worktree`.
2. New skill: `btrs-finish`.
3. New skill: `btrs-brainstorm`.
4. New skill: `btrs-execute` (subagent-driven with two-stage review).
5. Upgrade `btrs` router (session awareness, protocol injection, automatic chaining).
6. Upgrade `btrs-plan` (TDD-compatible task output).
7. Upgrade `btrs-init` (new three-tier structure, migration, expanded code-map).
8. Create `btrs/work/status.md` lifecycle.

### Phase 3 — Polish & Refinement

1. New skill: `btrs-receive-review`.
2. New skill: `btrs-request-review` (dispatch code review with structured context).
3. Add `btrs-dispatch` (parallel agent dispatch for independent tasks).
4. Deprecate `btrs-spec` (mark, don't remove).
5. Trim cross-platform sections from AGENTS.md.
6. Update `plugin.json` manifest.
7. Update documentation (docs/index.html, USAGE-GUIDE.md).
8. Rewrite README.md — comprehensive guide covering:
   - What BTRS is and what problem it solves (brief)
   - How to install (single command)
   - How to use it (`/btrs` as the only entry point, with examples)
   - What happens when you run `/btrs` (the workflow: session awareness → classify → plan → worktree → implement → review → sanity-check → finish)
   - The `btrs/` directory structure and what each tier contains
   - Discipline enforcement (TDD, verification, debugging) — what it does and why
   - The 24 agents — grouped by category with one-line descriptions
   - The 24 skills — grouped by purpose with when each is triggered
   - Session continuity — how `/btrs` picks up where you left off
   - Configuration and customization options
9. Update docs/index.html to match new README content.

---

## Final Skill Inventory (24 skills)

### Entry & Orchestration
| Skill | Status |
|-------|--------|
| `btrs` | Upgraded — session awareness, protocol injection, automatic chaining |
| `btrs-init` | Upgraded — three-tier structure, migration, expanded code-map |
| `btrs-execute` | New — subagent-driven plan execution with two-stage review |
| `btrs-handoff` | Existing — context translation between agents |

### Design & Planning
| Skill | Status |
|-------|--------|
| `btrs-brainstorm` | New — collaborative design → spec creation |
| `btrs-plan` | Upgraded — TDD-compatible task output |
| `btrs-propose` | Existing — decision matrices |
| `btrs-spec` | Deprecated — prefer btrs-brainstorm |

### Discipline (Iron Law)
| Skill | Status |
|-------|--------|
| `btrs-tdd` | New — test-first, red-green-refactor |
| `btrs-debug` | New — 4-phase systematic debugging |
| `btrs-verify` | Upgraded — paranoid verification |
| `btrs-receive-review` | New — anti-performative-agreement |
| `btrs-sanity-check` | New — 10-pass final sweep |

### Workflow
| Skill | Status |
|-------|--------|
| `btrs-worktree` | New — git worktree management |
| `btrs-finish` | New — branch completion (merge/PR/keep/discard) |
| `btrs-request-review` | New — dispatch structured code review |
| `btrs-dispatch` | New — parallel agent dispatch |

### Quality & Operations
| Skill | Status |
|-------|--------|
| `btrs-implement` | Existing |
| `btrs-review` | Existing |
| `btrs-audit` | Existing |
| `btrs-deploy` | Existing |
| `btrs-health` | Existing |
| `btrs-tech-debt` | Existing |
| `btrs-research` | Existing |
| `btrs-analyze` | Existing |
| `btrs-doc` | Existing |

**24 skills, 2 shared protocol files, 24 agents (all updated).**
