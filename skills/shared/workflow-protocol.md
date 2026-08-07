# Workflow Protocol

This protocol defines the expected order of operations and status display requirements. Read at Step 0 by every skill.

---

## 1. Workflow Order

These are expectations, not a rigid pipeline. Apply relevant rules based on task type.

- **Branch before implementation:** Create an isolated branch before any code changes.
- **Plan before multi-step work:** No multi-file implementations without a plan.
- **Rigor during implementation:** Follow the assessed rigor level (see `rigor-protocol.md`); tests are optional below strict.
- **Review after implementation:** Code review is required before branch completion.
- **Verify before claiming complete:** No completion claims without fresh evidence.

---

## 2. Status Display Protocol

Every skill and agent dispatch MUST provide live visibility into what is happening. Silent execution erodes trust.

### Rule 1: Task Checklist for Multi-Step Work

When a skill run involves 3+ distinct steps or agent dispatches, create TaskCreate
items for the major steps and update them as you go. Single-step or trivial runs
skip the checklist — announcing the action is enough.

Example:

```
☑ Reading project conventions
☐ Classifying request  ← (spinner: "Classifying request...")
☐ Dispatching btrs-web-engineer
☐ Verification
```

### Rule 2: Agent Dispatch Announcements

When dispatching any agent, announce explicitly before dispatch:

```
Dispatching btrs-web-engineer to implement Dashboard analytics widget
  Context: React + TypeScript project, Zustand for state, Tailwind CSS
  Injected: TDD protocol, project conventions
  Working in: feature/dashboard branch
```

### Rule 3: Verification Evidence Display

Every verification claim must show actual evidence inline:

```
Verification:
  Command: npm test
  Exit code: 0
  Result: 47 passed, 0 failed, 0 skipped
  ✓ Claim confirmed: "All tests pass"
```

### Rule 4: Workflow Position Indicator

For multi-step workflows, display current position:

```
Workflow: plan → [build] → review → verify → report
                  ^^^^^ you are here
```

---

## 3. State Management

Every state transition updates `btrs/status.md`:

- **Plan created** → add to active work
- **Task completed** → update progress
- **All tasks done** → trigger finish workflow
- **Branch merged/discarded** → move to recently completed

---

These rules are codified in this protocol so every skill inherits them. Skills MUST create task items for their steps. Agent dispatches MUST be announced with context. Verifications MUST show evidence. No silent execution.
