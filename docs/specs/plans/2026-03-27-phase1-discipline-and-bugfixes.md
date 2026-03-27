# Phase 1: Discipline & Bug Fixes — Implementation Plan

> **For agentic workers:** Use `btrs:btrs-boss` or dispatch specialist agents to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the AI/memory path inconsistency, add discipline enforcement protocols, create TDD/debug/sanity-check skills, and upgrade btrs-verify — making BTRS self-enforcing on code quality.

**Architecture:** Agent Protocol Upgrade pattern — shared protocol files get read by all skills at Step 0 and injected into agent dispatches. No pipeline or router changes in this phase.

**Tech Stack:** Markdown skill/agent definition files. No runtime code.

**Design Spec:** [2026-03-27-btrs-superpowers-merge-design.md](../2026-03-27-btrs-superpowers-merge-design.md)

---

## File Structure

### Files to Create

```
skills/shared/discipline-protocol.md          — Iron Law enforcement rules
skills/shared/workflow-protocol.md            — Workflow order + status display protocol
skills/btrs-tdd/SKILL.md                      — TDD skill (adapted from Superpowers)
skills/btrs-debug/SKILL.md                    — Systematic debugging skill (adapted from Superpowers)
skills/btrs-debug/root-cause-tracing.md       — Companion: backward tracing technique
skills/btrs-debug/defense-in-depth.md         — Companion: multi-layer validation
skills/btrs-debug/condition-based-waiting.md  — Companion: replace timeouts with polling
skills/btrs-sanity-check/SKILL.md             — 10-pass final sweep skill (new)
```

### Files to Modify

```
skills/shared/config.md                       — Update paths from .btrs/ to btrs/
skills/btrs-verify/SKILL.md                   — Iron Law upgrade
skills/btrs-init/SKILL.md                     — Expand code-map registry
skills/btrs-implement/SKILL.md                — Update Step 0
skills/btrs-review/SKILL.md                   — Update Step 0
skills/btrs-plan/SKILL.md                     — Update Step 0
skills/btrs-propose/SKILL.md                  — Update Step 0
skills/btrs-spec/SKILL.md                     — Update Step 0
skills/btrs-audit/SKILL.md                    — Update Step 0
skills/btrs-deploy/SKILL.md                   — Update Step 0
skills/btrs-health/SKILL.md                   — Update Step 0
skills/btrs-research/SKILL.md                 — Update Step 0
skills/btrs-analyze/SKILL.md                  — Update Step 0
skills/btrs-handoff/SKILL.md                  — Update Step 0
skills/btrs-doc/SKILL.md                      — Update Step 0
skills/btrs-tech-debt/SKILL.md                — Update Step 0
skills/btrs/SKILL.md                          — Update Step 0 (router)
agents/btrs-boss/AGENT.md                     — Path fix + protocol refs + cleanup
agents/btrs-architect/AGENT.md                — Path fix + protocol refs + cleanup
agents/btrs-api-engineer/AGENT.md             — Path fix + protocol refs + cleanup
agents/btrs-web-engineer/AGENT.md             — Path fix + protocol refs + code example removal
agents/btrs-mobile-engineer/AGENT.md          — Path fix + protocol refs + code example removal
agents/btrs-desktop-engineer/AGENT.md         — Path fix + protocol refs + code example removal
agents/btrs-ui-engineer/AGENT.md              — Path fix + protocol refs + cleanup
agents/btrs-database-engineer/AGENT.md        — Path fix + protocol refs + cleanup
agents/btrs-qa-test-engineering/AGENT.md       — Path fix + protocol refs + cleanup
agents/btrs-code-security/AGENT.md            — Path fix + protocol refs
agents/btrs-security-ops/AGENT.md             — Path fix + protocol refs
agents/btrs-documentation/AGENT.md            — Path fix + protocol refs
agents/btrs-research/AGENT.md                 — Path fix + protocol refs
agents/btrs-cloud-ops/AGENT.md                — Path fix + protocol refs
agents/btrs-cicd-ops/AGENT.md                 — Path fix + protocol refs
agents/btrs-container-ops/AGENT.md            — Path fix + protocol refs
agents/btrs-monitoring-ops/AGENT.md           — Path fix + protocol refs
agents/btrs-product/AGENT.md                  — Path fix + protocol refs
agents/btrs-marketing/AGENT.md                — Path fix + protocol refs
agents/btrs-sales/AGENT.md                    — Path fix + protocol refs
agents/btrs-accounting/AGENT.md               — Path fix + protocol refs
agents/btrs-customer-success/AGENT.md         — Path fix + protocol refs
agents/btrs-data-analyst/AGENT.md             — Path fix + protocol refs
agents/btrs-devops/AGENT.md                   — Path fix + protocol refs
```

---

## Task 1: Update shared config paths from `.btrs/` to `btrs/`

The config.md file is the source of truth for all paths. Every other file reads it. Fix this first so all subsequent work uses the correct paths.

**Files:**
- Modify: `skills/shared/config.md`

- [ ] **Step 1: Read the current config.md**

Read `skills/shared/config.md` in full.

- [ ] **Step 2: Replace all `.btrs/` references with `btrs/`**

Replace every instance of `.btrs/` with `btrs/` throughout the file. This includes:
- The vault path description (line 7-9 area)
- The config file path (`.btrs/config.json` → `btrs/config.json`)
- All standard paths in the directory tree
- All path references in the Writing Rules section
- All agent output paths
- ID convention references

- [ ] **Step 3: Update the directory structure to three-tier layout**

Replace the existing "Knowledge Areas" directory tree with the new three-tier structure:

```markdown
### Three-Tier Structure

```
btrs/
  config.json              # Project configuration
  index.md                 # Vault home page with navigation

  knowledge/               # Long-lived project truth
    conventions/           # Detected patterns, coding standards
    decisions/             # Architecture Decision Records
    code-map/              # Component/utility/hook/constant/type/API registry
      components.md
      utilities.md
      hooks.md
      constants.md
      types.md
      api.md
    tech-debt/             # Tracked debt items

  work/                    # Active work artifacts (lifecycle-managed)
    specs/                 # Feature specifications
    plans/                 # Implementation plans
    todos/                 # Work items and tasks
    changelog/             # Release notes, change records
    status.md              # Active work, blocked items, recent completions

  evidence/                # Audit trail (append-only, prunable)
    reviews/               # Code review reports
    verification/          # Verification evidence logs
    debug/                 # Root cause investigations
    sessions/              # Agent activity summaries

  .obsidian/               # Obsidian config
```
```

- [ ] **Step 4: Update the Agent Output Paths section**

Replace the per-agent output path section with:

```markdown
### Agent Output Paths

Agents write to the artifact tier that matches what they produce, not to a personal folder:

| Output Type | Path | Example Agents |
|-------------|------|----------------|
| Architecture decisions | `btrs/knowledge/decisions/` | architect, research |
| Conventions & patterns | `btrs/knowledge/conventions/` | architect, container-ops |
| Code registry updates | `btrs/knowledge/code-map/` | web-engineer, api-engineer |
| Tech debt items | `btrs/knowledge/tech-debt/` | any agent during verification |
| Feature specs | `btrs/work/specs/` | product, architect |
| Implementation plans | `btrs/work/plans/` | boss, architect |
| Task breakdowns | `btrs/work/todos/` | boss |
| Changelog entries | `btrs/work/changelog/` | any agent after implementation |
| Code reviews | `btrs/evidence/reviews/` | qa-test-engineering, code-security |
| Verification reports | `btrs/evidence/verification/` | any agent during self-verification |
| Debug investigations | `btrs/evidence/debug/` | any agent during debugging |
| Session summaries | `btrs/evidence/sessions/` | any agent |
```

- [ ] **Step 5: Update Writing Rules**

Update rule references from `.btrs/` to `btrs/`:
- Rule 1: "Read `btrs/config.json` before writing any output."
- Rule 2: "Do not invent new top-level directories under `btrs/`."
- Rule 3: Unchanged.
- Rule 4: "Link between vault files with `[[path/to/file]]` syntax. Use standard markdown links with relative paths for source code references."
- Rules 5-6: Unchanged.

- [ ] **Step 6: Commit**

```bash
git add skills/shared/config.md
git commit -m "Update config.md: .btrs/ → btrs/, add three-tier structure"
```

---

## Task 2: Create `skills/shared/discipline-protocol.md`

The core discipline enforcement document. Gets read at Step 0 by all skills and injected into agent dispatches.

**Files:**
- Create: `skills/shared/discipline-protocol.md`

- [ ] **Step 1: Create the discipline protocol file**

Write `skills/shared/discipline-protocol.md` with the following content. This adapts Superpowers' Iron Law patterns for BTRS:

```markdown
# Discipline Protocol

This protocol is mandatory for all implementation work. It is read at Step 0 by every skill and injected into every agent dispatch. Violating the letter of these rules is violating the spirit of these rules.

## Test-Driven Development

### The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

**No exceptions:**
- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Don't look at it
- Delete means delete

**The Cycle:**
1. **RED** — Write one minimal failing test. Verify it fails for the right reason.
2. **GREEN** — Write the simplest code to make it pass. Nothing more.
3. **REFACTOR** — Clean up while staying green. Don't add behavior.
4. **Repeat** — Next failing test for next behavior.

**Test passes immediately?** You're testing existing behavior. Fix the test.
**Test errors?** Fix the error, re-run until it fails correctly.

**When to use:** Always — new features, bug fixes, refactoring, behavior changes.
**Exceptions (ask user):** Throwaway prototypes, generated code, configuration files.

For the full TDD skill with examples and companion guidance, invoke `btrs-tdd`.

### Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Already manually tested" | Ad-hoc ≠ systematic. No record, can't re-run. |
| "Deleting X hours is wasteful" | Sunk cost fallacy. Keeping unverified code is technical debt. |
| "TDD will slow me down" | TDD is faster than debugging. |
| "Just this once" | That's rationalization. Stop. |

## Verification

### The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

**The 5-Step Gate (skip any = lying, not verifying):**
1. **IDENTIFY** — What command proves this claim?
2. **RUN** — Execute the full command. Fresh. Now. Not recalled from earlier.
3. **READ** — Full output. Check exit code. Count failures.
4. **VERIFY** — Does the output actually confirm the claim?
5. **CLAIM** — Only now may you state it.

**Forbidden words in success claims:** "should", "probably", "seems to", "I believe", "likely".

**Forbidden behavior:** Expressing satisfaction ("Great!", "Done!", "All good!") before running verification. If you catch yourself doing this, STOP and run verification first.

For the full verification skill with evidence formats, invoke `btrs-verify`.

## Debugging

### The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

**The 4 Phases (complete each before proceeding):**
1. **Root Cause Investigation** — Read errors carefully, reproduce consistently, check recent changes, trace data flow.
2. **Pattern Analysis** — Find working examples, compare against references completely, identify all differences.
3. **Hypothesis & Testing** — Form ONE specific hypothesis, test minimally, ONE variable at a time.
4. **Implementation** — Create failing test first, implement single fix, verify.

**After 3 failed fix attempts:** STOP. Question the architecture. Discuss with the user before attempting more fixes.

For the full debugging skill with companion techniques, invoke `btrs-debug`.

## Dependency Justification

Before adding any third-party package, you MUST justify it against three alternatives:

1. **Native/built-in API** — Does the language or runtime already provide this? (`fetch` vs `axios`, `crypto.randomUUID()` vs `uuid`, `structuredClone` vs `lodash.cloneDeep`)
2. **Write it yourself** — Could this be a 5-20 line utility function? If the package source for the function you're using is shorter than the `package.json` entry, write it yourself.
3. **Existing project package** — Does the project already have a package that does this? Don't add `dayjs` if `date-fns` is already installed.

**The dependency is the last resort, not the first.** If any alternative works, use it.

**When you do add a dependency:** Check its maintenance status, known vulnerabilities, transitive dependency count, and usage ratio (are you using 1 function from a 200-function library?).

## Duplication Prevention

Before creating any new function, constant, type, or component:

1. **Check the code-map registry** — Read `btrs/knowledge/code-map/` for existing implementations.
2. **Grep the codebase** — The registry is a snapshot, not the complete picture. Search for similar names, signatures, and logic.
3. **If something does 80% of what you need** — Extend it rather than creating a duplicate.

## Performance Awareness

Before writing a loop that touches a database, API, or collection:

- **State the expected time complexity.** If worse than O(n), justify why.
- **Avoid:** `await` inside loops (use `Promise.all` or batch), queries inside loops (N+1), nested loops over the same collection, fetching full objects when a subset would do.

## Escape Clause

If the user explicitly requests skipping any discipline rule for a specific change, acknowledge the request and proceed. The user always takes precedence. The key word is *explicitly* — not by implication.
```

- [ ] **Step 2: Commit**

```bash
git add skills/shared/discipline-protocol.md
git commit -m "Add discipline-protocol.md: TDD, verification, debugging Iron Laws"
```

---

## Task 3: Create `skills/shared/workflow-protocol.md`

Defines workflow order and the status display protocol.

**Files:**
- Create: `skills/shared/workflow-protocol.md`

- [ ] **Step 1: Create the workflow protocol file**

Write `skills/shared/workflow-protocol.md`:

```markdown
# Workflow Protocol

This protocol defines the expected order of operations and status display requirements. Read at Step 0 by every skill.

## Workflow Order

These are expectations, not a rigid pipeline. Apply the relevant rules based on the task type.

- **Worktree before implementation:** Create an isolated branch/worktree before any code changes.
- **Plan before multi-step work:** No multi-file implementations without a plan.
- **TDD during implementation:** Follow the discipline protocol's TDD mandate.
- **Review after implementation:** Code review is required before branch completion.
- **Sanity check before finish:** `btrs-sanity-check` must pass before `btrs-finish`.
- **Verify before claiming complete:** Follow the discipline protocol's verification mandate.

## Status Display Protocol

Every skill and agent dispatch MUST provide live visibility. Silent execution erodes trust.

### Rule 1: Task Checklist for Every Skill

When any skill starts, create TaskCreate items for each major step. Update to `in_progress` when starting, `completed` when done. The user sees real-time progress.

### Rule 2: Agent Dispatch Announcements

When dispatching any agent, announce explicitly before dispatch:

```
Dispatching btrs-web-engineer to implement Dashboard analytics widget
  Context: React + TypeScript project, Zustand for state, Tailwind CSS
  Injected: TDD protocol, project conventions
  Working in: btrs-worktrees/feat-dashboard/
```

### Rule 3: Pass-by-Pass Status for Multi-Step Checks

Skills with multiple internal passes (especially `btrs-sanity-check`) display each pass as a task item with its result.

### Rule 4: Verification Evidence Display

Every verification claim must show the actual evidence inline:

```
Verification:
  Command: npm test
  Exit code: 0
  Result: 47 passed, 0 failed, 0 skipped
  ✓ Claim confirmed: "All tests pass"
```

### Rule 5: Workflow Position Indicator

For multi-step workflows, display the current position:

```
Workflow: brainstorm → plan → [worktree] → execute → sanity-check → finish
                               ^^^^^^^^^ you are here
```

## State Management

Every state transition updates `btrs/work/status.md`:
- Plan created → add to active work
- Task completed → update progress
- All tasks done → trigger finish workflow
- Branch merged/discarded → move to recently completed
```

- [ ] **Step 2: Commit**

```bash
git add skills/shared/workflow-protocol.md
git commit -m "Add workflow-protocol.md: workflow order + status display rules"
```

---

## Task 4: Create `skills/btrs-tdd/SKILL.md`

Adapted from Superpowers' TDD skill. Preserves Iron Law language verbatim where it matters.

**Files:**
- Create: `skills/btrs-tdd/SKILL.md`

- [ ] **Step 1: Create the btrs-tdd skill directory**

```bash
mkdir -p skills/btrs-tdd
```

- [ ] **Step 2: Write the TDD skill**

Write `skills/btrs-tdd/SKILL.md`. This adapts the Superpowers TDD skill with BTRS frontmatter, Step 0 pattern, and btrs/ path references. Preserve the Iron Law, rationalization tables, red flags, and deletion mandate verbatim from the Superpowers source. Key adaptations:

- BTRS frontmatter format (name, description, disable-model-invocation, allowed-tools, argument-hint)
- Step 0 reads `skills/shared/config.md`, `skills/shared/discipline-protocol.md`, `skills/shared/workflow-protocol.md`
- Replace `superpowers:verification-before-completion` references with `btrs-verify`
- Replace `superpowers:test-driven-development` self-references with `btrs-tdd`
- Add BTRS anti-patterns section at the bottom matching BTRS skill style
- Reference `btrs/evidence/verification/` for storing test evidence
- Include the full Red-Green-Refactor cycle with dot diagram
- Include the complete rationalization table (all 11 excuses)
- Include the complete Red Flags list (all 13 items)
- Include the verification checklist
- Include the When Stuck table
- Include the debugging integration section (reference `btrs-debug` instead of Superpowers)
- Include Good Tests quality table
- Include the Bug Fix example

- [ ] **Step 3: Commit**

```bash
git add skills/btrs-tdd/SKILL.md
git commit -m "Add btrs-tdd skill: TDD with Iron Law enforcement"
```

---

## Task 5: Create `skills/btrs-debug/SKILL.md` and companion files

Adapted from Superpowers' systematic-debugging skill. Preserves Iron Law language and 4-phase structure.

**Files:**
- Create: `skills/btrs-debug/SKILL.md`
- Create: `skills/btrs-debug/root-cause-tracing.md`
- Create: `skills/btrs-debug/defense-in-depth.md`
- Create: `skills/btrs-debug/condition-based-waiting.md`

- [ ] **Step 1: Create the btrs-debug skill directory**

```bash
mkdir -p skills/btrs-debug
```

- [ ] **Step 2: Write the debugging skill**

Write `skills/btrs-debug/SKILL.md`. Adapts the Superpowers systematic-debugging skill with BTRS conventions. Key adaptations:

- BTRS frontmatter format
- Step 0 reads shared config, discipline protocol, workflow protocol
- Replace `superpowers:test-driven-development` reference with `btrs-tdd`
- Replace `superpowers:verification-before-completion` reference with `btrs-verify`
- Preserve verbatim: Iron Law, 4-phase structure, Phase 4.5 architecture escape hatch, Red Flags list, Common Rationalizations table, multi-component diagnostic instrumentation example
- Write debug investigation reports to `btrs/evidence/debug/`
- Reference companion files in the same directory
- Add BTRS anti-patterns section at the bottom

- [ ] **Step 3: Copy and adapt companion files**

Read the three companion files from the Superpowers source at:
- `/Users/brandonbuttars/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.6/skills/systematic-debugging/root-cause-tracing.md`
- `/Users/brandonbuttars/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.6/skills/systematic-debugging/defense-in-depth.md`
- `/Users/brandonbuttars/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.6/skills/systematic-debugging/condition-based-waiting.md`

Adapt each for BTRS:
- Update any Superpowers skill references to BTRS equivalents
- Update any path references to btrs/ structure
- Preserve all technical content verbatim

Write to:
- `skills/btrs-debug/root-cause-tracing.md`
- `skills/btrs-debug/defense-in-depth.md`
- `skills/btrs-debug/condition-based-waiting.md`

- [ ] **Step 4: Commit**

```bash
git add skills/btrs-debug/
git commit -m "Add btrs-debug skill: systematic debugging with Iron Law enforcement"
```

---

## Task 6: Upgrade `skills/btrs-verify/SKILL.md`

Merge Superpowers' paranoid verification into the existing BTRS verify skill.

**Files:**
- Modify: `skills/btrs-verify/SKILL.md`

- [ ] **Step 1: Read the current btrs-verify skill in full**

Read `skills/btrs-verify/SKILL.md` completely to understand current structure.

- [ ] **Step 2: Update Step 0 to read new protocols**

Add to Step 0 after the existing reads:
```markdown
5. Read `skills/shared/discipline-protocol.md` for the verification Iron Law.
6. Read `skills/shared/workflow-protocol.md` for status display requirements.
```

- [ ] **Step 3: Add the Iron Law section after the frontmatter**

Insert between the description paragraph and "## Workflow":

```markdown
## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

**The 5-Step Gate (skip any step = lying, not verifying):**
1. **IDENTIFY** — What command proves this claim?
2. **RUN** — Execute the full command. Fresh. In this session. Not recalled from earlier.
3. **READ** — Read the full output. Check the exit code. Count failures.
4. **VERIFY** — Does the output actually confirm the claim?
5. **CLAIM** — Only now may you state it.

**Forbidden words in success claims:** "should", "probably", "seems to", "I believe", "likely".

**Forbidden behavior:** Expressing satisfaction before verification. "Great!", "Done!", "All good!" before running the actual command means you are claiming without evidence.

### Red Flags — STOP and Verify

If you catch yourself:
- Using "should" or "probably" about test results
- Saying "Done!" before running verification
- Trusting a previous run instead of running fresh
- Trusting an agent's success report without independent verification
- Saying "tests pass" without showing the actual output
- Skipping verification because "the change is trivial"

**ALL of these mean: STOP. Run the verification command. Show the evidence.**
```

- [ ] **Step 4: Update the report format to include evidence**

In Step 6 (Produce the report), add after the Summary section:

```markdown
### Verification Evidence

For each claim verified by running a command, show:
```
Command: <exact command run>
Exit code: <code>
Output: <relevant output lines>
✓ or ✗ Claim: "<the claim being verified>"
```
```

- [ ] **Step 5: Update all `.btrs/` path references to `btrs/`**

Replace all `.btrs/` references in the file with `btrs/`.

- [ ] **Step 6: Commit**

```bash
git add skills/btrs-verify/SKILL.md
git commit -m "Upgrade btrs-verify: add Iron Law enforcement and evidence display"
```

---

## Task 7: Create `skills/btrs-sanity-check/SKILL.md`

New skill — 10-pass final sweep before branch completion.

**Files:**
- Create: `skills/btrs-sanity-check/SKILL.md`

- [ ] **Step 1: Create the directory**

```bash
mkdir -p skills/btrs-sanity-check
```

- [ ] **Step 2: Write the sanity check skill**

Write `skills/btrs-sanity-check/SKILL.md`:

```yaml
---
name: btrs-sanity-check
description: 10-pass paranoid final sweep before branch completion. Catches regressions, leaks, dead code, debug artifacts, dependency issues, type errors, duplication, and performance problems. Required before btrs-finish.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *)
argument-hint: [branch or directory to check]
---
```

Content must include:

**The Iron Law:**
```
NO BRANCH FINISHES WITHOUT A CLEAN SANITY CHECK
```

**Step 0:** Read config.md, discipline-protocol.md, workflow-protocol.md, btrs/knowledge/conventions/.

**Step 1:** Determine scope — all changes since branch diverged from base (`git diff --name-only $(git merge-base HEAD main)..HEAD`). List all changed files.

**Step 2:** Create TaskCreate items for all 10 passes. Display pass-by-pass status per workflow protocol Rule 3.

**The 10 Passes:**

**Pass 1 — Regression:**
- Run the full test suite.
- If a worktree baseline exists (captured at creation), diff results against baseline.
- Any new failures = STOP. Report and do not proceed.
- Evidence: show command, exit code, pass/fail counts.

**Pass 2 — Leak & Resource:**
- Grep changed files for patterns: unclosed connections, missing `.close()`/`.dispose()`/`.destroy()`, `addEventListener` without `removeEventListener`, `setInterval` without `clearInterval`, `subscribe` without `unsubscribe`, missing `finally` blocks on resource acquisition.
- Report each finding with file:line.

**Pass 3 — Dead Code:**
- Grep changed files for: unused imports, unused variables, unreachable code after `return`/`throw`, commented-out code blocks (>2 lines), functions defined but never called (grep for definition, then grep for usage).
- Report each finding with file:line.

**Pass 4 — Debug Artifacts:**
- Grep changed files for: `console.log`, `console.debug`, `console.warn` (unless in error handlers), `debugger`, `TODO` or `FIXME` introduced in this branch (not pre-existing), hardcoded `localhost` or test values, `.only` on test cases, `// @ts-ignore` or `// @ts-expect-error` without explanation.
- Report each finding with file:line.

**Pass 5 — Behavioral Regression:**
- For every changed file: read the git diff. For each function or component modified, ask: "Could this change break existing behavior that isn't covered by a test?"
- Flag anything uncertain with the specific concern.
- This is a judgment call — err on the side of flagging.

**Pass 6 — Dependency Health:**
- If `package.json` (or equivalent) was modified: list new dependencies added.
- For each new dependency: check if it's maintained (last publish date), check for known vulnerabilities (`npm audit` or equivalent), check if it duplicates an existing dependency.
- Report findings per dependency.

**Pass 7 — Dependency Justification:**
- For each new dependency from Pass 6: check usage ratio (how many exports are imported?), check for native alternative, check if implementation is trivial (<20 lines), check transitive dependency count.
- Flag any dependency that fails justification.

**Pass 8 — Type Safety:**
- Run the type checker if applicable (`npx tsc --noEmit` or equivalent).
- Grep changed files for new `any` types, type assertions (`as`), `@ts-ignore`, `@ts-expect-error`.
- Report each finding with file:line.

**Pass 9 — Duplication:**
- For every new function, constant, type, or component introduced: grep the rest of the codebase for similar names and signatures.
- Check against `btrs/knowledge/code-map/` registry.
- Flag potential duplicates for review.

**Pass 10 — Performance:**
- Grep changed files for: nested loops over the same collection, `await` inside `for`/`while` loops, database queries inside loops (N+1 pattern), missing pagination on list queries, large object creation where a subset would suffice, expensive computations in React render paths without memoization.
- Report each finding with file:line and the specific concern.

**Step 3:** Produce the sanity check report:

```markdown
# Sanity Check Report

## Summary
- Files scanned: N
- Passes: 10
- Findings: N (X critical, Y warning, Z info)
- **Overall status**: CLEAN | HAS_FINDINGS | BLOCKED

## Pass Results
| # | Pass | Status | Findings |
|---|------|--------|----------|
| 1 | Regression | ✓ CLEAN | 47 tests passed, 0 failures |
| 2 | Leak & Resource | ✓ CLEAN | No issues |
| 3 | Dead Code | ⚠ WARNING | 2 unused imports |
...

## Findings Detail
[Each finding with file:line, severity, and description]

## Recommendation
[PROCEED / FIX_REQUIRED / BLOCKED with specific items to address]
```

**Step 4:** Write output:
- Present report to user.
- Write to `btrs/evidence/verification/sanity-check-{branch}-{date}.md`.
- If BLOCKED: do not allow `btrs-finish` to proceed.

**Anti-patterns:**
- Do not skip passes because "the change is small."
- Do not mark CLEAN without running the actual checks.
- Do not auto-fix findings — report only. Use `btrs-implement` to fix.
- Do not ignore Pass 5 (behavioral regression) because "tests pass." Tests don't cover everything.
- Do not run only the passes you think are relevant. All 10, every time.

- [ ] **Step 3: Commit**

```bash
git add skills/btrs-sanity-check/SKILL.md
git commit -m "Add btrs-sanity-check skill: 10-pass paranoid final sweep"
```

---

## Task 8: Update Step 0 across all existing skills

Add discipline and workflow protocol reads to every existing skill's Step 0.

**Files:**
- Modify: All 16 existing skill SKILL.md files (including router)

- [ ] **Step 1: Read each skill's current Step 0**

Read the Step 0 section of each of the 16 existing skills to understand their current reads. Note: `btrs-tech-debt` and `btrs-init` use `~/.claude/skills/btrs-shared/config.md` — these need path standardization too.

- [ ] **Step 2: Update each skill's Step 0**

For each skill, add two new reads to the end of Step 0:

```markdown
N. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
N+1. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.
```

Where N is the next number after existing Step 0 reads.

**Also for each skill:** Replace all `.btrs/` path references with `btrs/` throughout the entire file.

**Special cases:**
- `btrs-tech-debt` and `btrs-init`: Also fix `~/.claude/skills/btrs-shared/config.md` → `skills/shared/config.md` to match the standard pattern.
- `btrs` router: Step 0 is "Check initialization" — add protocol reads as sub-steps.
- `btrs-verify`: Already updated in Task 6 — skip.

The 15 skills to update (btrs-verify already done):
1. `skills/btrs/SKILL.md`
2. `skills/btrs-init/SKILL.md`
3. `skills/btrs-implement/SKILL.md`
4. `skills/btrs-review/SKILL.md`
5. `skills/btrs-plan/SKILL.md`
6. `skills/btrs-propose/SKILL.md`
7. `skills/btrs-spec/SKILL.md`
8. `skills/btrs-audit/SKILL.md`
9. `skills/btrs-deploy/SKILL.md`
10. `skills/btrs-health/SKILL.md`
11. `skills/btrs-research/SKILL.md`
12. `skills/btrs-analyze/SKILL.md`
13. `skills/btrs-handoff/SKILL.md`
14. `skills/btrs-doc/SKILL.md`
15. `skills/btrs-tech-debt/SKILL.md`

- [ ] **Step 3: Commit**

```bash
git add skills/btrs/SKILL.md skills/btrs-init/SKILL.md skills/btrs-implement/SKILL.md \
  skills/btrs-review/SKILL.md skills/btrs-plan/SKILL.md skills/btrs-propose/SKILL.md \
  skills/btrs-spec/SKILL.md skills/btrs-audit/SKILL.md skills/btrs-deploy/SKILL.md \
  skills/btrs-health/SKILL.md skills/btrs-research/SKILL.md skills/btrs-analyze/SKILL.md \
  skills/btrs-handoff/SKILL.md skills/btrs-doc/SKILL.md skills/btrs-tech-debt/SKILL.md
git commit -m "Update Step 0 across all skills: add discipline + workflow protocol reads, fix btrs/ paths"
```

---

## Task 9: Fix agent bodies — path migration

Replace all `AI/memory/` references with `btrs/` tier paths across all 24 agents.

**Files:**
- Modify: All 24 `agents/btrs-*/AGENT.md` files

- [ ] **Step 1: Read each agent's Memory Locations section**

For each of the 24 agents, read the section that defines read/write paths (typically "Memory Locations", "Read Access", "Write Access", or similar headers). Note every `AI/memory/` and `AI/logs/` path.

- [ ] **Step 2: Replace paths using the mapping**

Apply the path mapping from the design spec. The general rules:

| Old Path Pattern | New Path | Logic |
|-----------------|----------|-------|
| `AI/memory/agents/{name}/active-tasks*` | `btrs/work/todos/` | Task management |
| `AI/memory/agents/{name}/priorities*` | `btrs/work/status.md` | Status tracking |
| `AI/memory/agents/{name}/implementation-notes*` | `btrs/evidence/sessions/` | Session artifacts |
| `AI/memory/agents/{name}/design-decisions*` | `btrs/knowledge/decisions/` | Architecture |
| `AI/memory/agents/{name}/patterns*` | `btrs/knowledge/conventions/` | Conventions |
| `AI/memory/agents/{name}/findings*` | `btrs/knowledge/decisions/` | Research output |
| `AI/memory/agents/{name}/vulnerabilities*` | `btrs/evidence/reviews/` | Security findings |
| `AI/memory/agents/{name}/test-*` | `btrs/evidence/reviews/` | QA output |
| `AI/memory/agents/{name}/metrics*` | `btrs/evidence/sessions/` | Metric snapshots |
| `AI/memory/agents/{name}/*-config*` | `btrs/knowledge/conventions/` | Config/conventions |
| `AI/memory/agents/{name}/playbooks*` | `btrs/knowledge/conventions/` | Playbooks |
| `AI/memory/agents/{name}/incidents*` | `btrs/evidence/debug/` | Incident logs |
| `AI/memory/agents/{name}/compliance*` | `btrs/knowledge/decisions/` | Compliance records |
| `AI/memory/global/project-state*` | `btrs/work/status.md` | Project state |
| `AI/memory/global/shared-context*` | `btrs/work/status.md` | Shared context |
| `AI/memory/global/architecture-decisions*` | `btrs/knowledge/decisions/` | ADRs |
| `AI/docs/architecture/` | `btrs/knowledge/decisions/` | Arch docs |
| `AI/logs/{name}.log` | `btrs/evidence/sessions/` | Agent logs |

Also replace any `.btrs/` references with `btrs/` (no dot).

- [ ] **Step 3: Commit agents in batches**

Commit in logical groups to keep commits reviewable:

```bash
# Management + Technical agents
git add agents/btrs-boss/AGENT.md agents/btrs-architect/AGENT.md \
  agents/btrs-qa-test-engineering/AGENT.md agents/btrs-documentation/AGENT.md \
  agents/btrs-research/AGENT.md
git commit -m "Fix AI/memory → btrs/ paths: management and technical agents"

# Engineering agents
git add agents/btrs-api-engineer/AGENT.md agents/btrs-web-engineer/AGENT.md \
  agents/btrs-mobile-engineer/AGENT.md agents/btrs-desktop-engineer/AGENT.md \
  agents/btrs-ui-engineer/AGENT.md agents/btrs-database-engineer/AGENT.md
git commit -m "Fix AI/memory → btrs/ paths: engineering agents"

# Security agents
git add agents/btrs-code-security/AGENT.md agents/btrs-security-ops/AGENT.md
git commit -m "Fix AI/memory → btrs/ paths: security agents"

# Operations agents
git add agents/btrs-cloud-ops/AGENT.md agents/btrs-cicd-ops/AGENT.md \
  agents/btrs-container-ops/AGENT.md agents/btrs-monitoring-ops/AGENT.md \
  agents/btrs-devops/AGENT.md
git commit -m "Fix AI/memory → btrs/ paths: operations agents"

# Business agents
git add agents/btrs-product/AGENT.md agents/btrs-marketing/AGENT.md \
  agents/btrs-sales/AGENT.md agents/btrs-accounting/AGENT.md \
  agents/btrs-customer-success/AGENT.md agents/btrs-data-analyst/AGENT.md
git commit -m "Fix AI/memory → btrs/ paths: business agents"
```

---

## Task 10: Fix agent bodies — remove generic code examples, add protocol references

Replace hardcoded code examples with convention-reading directives and add protocol reference blocks.

**Files:**
- Modify: All 24 `agents/btrs-*/AGENT.md` files (same files as Task 9)

- [ ] **Step 1: Identify agents with large code example sections**

The agents with significant hardcoded code blocks to replace:
- `btrs-web-engineer` — ~350 lines of React/Zustand/Axios/CSS examples
- `btrs-api-engineer` — ~570 lines of Express/middleware/validation examples
- `btrs-mobile-engineer` — ~640 lines of React Native examples
- `btrs-desktop-engineer` — ~370 lines of Electron examples
- `btrs-database-engineer` — Prisma schema and query examples
- `btrs-ui-engineer` — Design token and component library code

- [ ] **Step 2: Replace code examples with convention-reading directives**

For each agent with large code blocks, replace the code example sections with:

```markdown
## Implementation Patterns

Read the project's detected conventions before writing any code:
- `btrs/knowledge/conventions/framework.md`
- `btrs/knowledge/conventions/libraries.md`
- `btrs/knowledge/conventions/patterns.md`

Follow existing project patterns. Do NOT use patterns from your training data if they conflict with what the project actually uses.

For domain-specific conventions, also check:
- `btrs/knowledge/conventions/{domain}.md` (e.g., ui.md, api.md, database.md, testing.md)
- `btrs/knowledge/code-map/` for existing components, utilities, types, and constants
```

**Keep:** Any agent-specific workflow steps, communication templates, decision frameworks, and behavioral instructions. Only remove the generic code examples.

**For business agents** (product, marketing, sales, accounting, customer-success, data-analyst): Replace JSON schema examples for memory objects with references to the btrs/ tier they write to. Keep their workflow steps and frameworks.

- [ ] **Step 3: Add protocol reference blocks to all 24 agents**

Add to every agent's footer section (after existing Scoped Dispatch / Self-Verification / Convention Compliance blocks):

```markdown
## Discipline Protocol

Read and follow `skills/shared/discipline-protocol.md` for all implementation work. This includes:
- TDD mandate: no production code without a failing test first
- Verification mandate: no completion claims without fresh evidence
- Debugging mandate: no fixes without root cause investigation
- Dependency justification: native/self-write/existing before new package
- Duplication prevention: grep before creating

## Workflow Protocol

Read and follow `skills/shared/workflow-protocol.md` for:
- Status display: create task items, announce dispatches, show evidence
- Workflow order: worktree → plan → TDD → implement → review → verify → finish
- State management: update btrs/work/status.md on transitions
```

- [ ] **Step 4: Commit agents in batches**

```bash
# Engineering agents (largest changes — code example removal)
git add agents/btrs-web-engineer/AGENT.md agents/btrs-api-engineer/AGENT.md \
  agents/btrs-mobile-engineer/AGENT.md agents/btrs-desktop-engineer/AGENT.md \
  agents/btrs-ui-engineer/AGENT.md agents/btrs-database-engineer/AGENT.md
git commit -m "Replace generic code examples with convention directives, add protocol refs: engineering agents"

# Management + Technical agents
git add agents/btrs-boss/AGENT.md agents/btrs-architect/AGENT.md \
  agents/btrs-qa-test-engineering/AGENT.md agents/btrs-documentation/AGENT.md \
  agents/btrs-research/AGENT.md
git commit -m "Add protocol references, clean up memory schemas: management and technical agents"

# Security + Operations + Business agents
git add agents/btrs-code-security/AGENT.md agents/btrs-security-ops/AGENT.md \
  agents/btrs-cloud-ops/AGENT.md agents/btrs-cicd-ops/AGENT.md \
  agents/btrs-container-ops/AGENT.md agents/btrs-monitoring-ops/AGENT.md \
  agents/btrs-devops/AGENT.md agents/btrs-product/AGENT.md \
  agents/btrs-marketing/AGENT.md agents/btrs-sales/AGENT.md \
  agents/btrs-accounting/AGENT.md agents/btrs-customer-success/AGENT.md \
  agents/btrs-data-analyst/AGENT.md
git commit -m "Add protocol references: security, operations, and business agents"
```

---

## Task 11: Expand code-map registry in `btrs-init`

Add constants and API registry detection to the init skill.

**Files:**
- Modify: `skills/btrs-init/SKILL.md`

- [ ] **Step 1: Read the current btrs-init skill**

Read `skills/btrs-init/SKILL.md` in full. Find the Step 4 registry generation section and identify where to add new sub-steps.

- [ ] **Step 2: Update Step 0 paths**

Fix `~/.claude/skills/btrs-shared/config.md` → `skills/shared/config.md`. Add discipline and workflow protocol reads. Replace all `.btrs/` with `btrs/`.

- [ ] **Step 3: Add constants detection sub-step**

After existing registry steps, add:

```markdown
#### Step 4f: Constants and enums

1. Glob for files in `constants/`, `config/`, `lib/` directories.
2. Grep for `export const`, `export enum`, `export default {` patterns in non-component, non-test files.
3. For each found: extract the constant name, type, and file path.
4. Write to `btrs/knowledge/code-map/constants.md`:

```markdown
---
title: Constants & Enums Registry
updated: YYYY-MM-DD
---

# Constants & Enums

| Name | Type | File | Description |
|------|------|------|-------------|
| `API_BASE_URL` | string | `src/config/api.ts:3` | Base URL for API requests |
| `UserRole` | enum | `src/types/user.ts:8` | User permission roles |
```
```

- [ ] **Step 4: Add API detection sub-step**

```markdown
#### Step 4g: API definitions

1. Glob for files in `api/`, `services/`, `routes/` directories.
2. Grep for route definitions (`router.get`, `router.post`, `app.get`, `@Get`, `@Post`, etc.) and API client methods (`export const *Api`, `export function fetch*`).
3. For each found: extract the endpoint/method name, HTTP method, path, and file.
4. Write to `btrs/knowledge/code-map/api.md`:

```markdown
---
title: API Registry
updated: YYYY-MM-DD
---

# API Endpoints

| Method | Path | Handler | File |
|--------|------|---------|------|
| GET | `/api/users` | `getUsers` | `src/api/users.ts:12` |
| POST | `/api/auth/login` | `login` | `src/api/auth.ts:24` |

# API Client Methods

| Name | Endpoint | File |
|------|----------|------|
| `fetchUsers` | `GET /api/users` | `src/services/userService.ts:8` |
```
```

- [ ] **Step 5: Commit**

```bash
git add skills/btrs-init/SKILL.md
git commit -m "Expand btrs-init: add constants and API registry detection, fix paths"
```

---

## Self-Review Checklist

After completing all tasks, verify:

- [ ] **Spec coverage:** Every item in Phase 1 of the design spec has a corresponding task.
  - ✓ Fix AI/memory → btrs/ paths (Tasks 9)
  - ✓ Create discipline-protocol.md (Task 2)
  - ✓ Create workflow-protocol.md (Task 3)
  - ✓ New skill: btrs-tdd (Task 4)
  - ✓ New skill: btrs-debug (Task 5)
  - ✓ Upgrade btrs-verify (Task 6)
  - ✓ New skill: btrs-sanity-check (Task 7)
  - ✓ Update all skills' Step 0 (Task 8)
  - ✓ Fix agent bodies: remove code examples, add protocol refs (Task 10)
  - ✓ Expand code-map registry (Task 11)
  - ✓ Update config.md paths (Task 1 — prerequisite)

- [ ] **Placeholder scan:** No TBD, TODO, or "fill in details" in any task.

- [ ] **Type/name consistency:** All path references use `btrs/` (no `.btrs/`), all skill references use `btrs-*` naming, all protocol files referenced consistently.

- [ ] **Task ordering:** Tasks build on each other correctly:
  1. Config paths first (everything depends on this)
  2-3. Protocol files (skills and agents reference these)
  4-5. New skills (reference protocols)
  6. Verify upgrade (references protocols)
  7. Sanity check (references protocols)
  8. Update existing skills Step 0 (adds protocol reads)
  9-10. Agent body fixes (reference btrs/ paths and protocols)
  11. Init expansion (uses new btrs/ paths)
