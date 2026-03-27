# Workflow Protocol

This protocol defines the expected order of operations and status display requirements. Read at Step 0 by every skill.

---

## 1. Workflow Order

These are expectations, not a rigid pipeline. Apply relevant rules based on task type.

- **Worktree before implementation:** Create isolated branch/worktree before any code changes.
- **Plan before multi-step work:** No multi-file implementations without a plan.
- **TDD during implementation:** Follow the discipline protocol's TDD mandate.
- **Review after implementation:** Code review is required before branch completion.
- **Sanity check before finish:** `btrs-sanity-check` must pass before `btrs-finish`.
- **Verify before claiming complete:** Follow the discipline protocol's verification mandate.

---

## 2. Status Display Protocol

Every skill and agent dispatch MUST provide live visibility into what is happening. Silent execution erodes trust.

### Rule 1: Task Checklist for Every Skill

When any skill starts, create TaskCreate items for each major step. Update to in_progress when starting, completed when done. The user sees real-time progress.

Example:

```
☑ Reading project conventions
☑ Checking btrs/work/status.md for active work
☐ Classifying request  ← (spinner: "Classifying request...")
☐ Dispatching btrs-web-engineer
☐ Running sanity check
☐ Verification
```

### Rule 2: Agent Dispatch Announcements

When dispatching any agent, announce explicitly before dispatch:

```
Dispatching btrs-web-engineer to implement Dashboard analytics widget
  Context: React + TypeScript project, Zustand for state, Tailwind CSS
  Injected: TDD protocol, project conventions
  Working in: btrs-worktrees/feat-dashboard/
```

### Rule 3: Pass-by-Pass Status for Multi-Step Checks

Skills with multiple internal passes (especially btrs-sanity-check) display each pass as a task item with its result:

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

### Rule 4: Verification Evidence Display

Every verification claim must show actual evidence inline:

```
Verification:
  Command: npm test
  Exit code: 0
  Result: 47 passed, 0 failed, 0 skipped
  ✓ Claim confirmed: "All tests pass"
```

### Rule 5: Workflow Position Indicator

For multi-step workflows, display current position:

```
Workflow: brainstorm → plan → [worktree] → execute → sanity-check → finish
                               ^^^^^^^^^ you are here
```

---

## 3. State Management

Every state transition updates `btrs/work/status.md`:

- **Plan created** → add to active work
- **Task completed** → update progress
- **All tasks done** → trigger finish workflow
- **Branch merged/discarded** → move to recently completed

---

These rules are codified in this protocol so every skill inherits them. Skills MUST create task items for their steps. Agent dispatches MUST be announced with context. Verifications MUST show evidence. No silent execution.
