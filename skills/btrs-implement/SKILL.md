---
name: btrs-implement
description: Write code from a spec, todo, or description. Follows project conventions, reuses existing components, and self-verifies. Use when implementing features, building from specs, or coding tasks.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Edit, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *), Bash(node *)
argument-hint: <spec-id, todo-id, or description>
---

# /btrs-implement

Implementation skill. Builds features from specs, todos, or descriptions. Reads conventions and the component registry, follows canonical examples, reuses existing code, and self-verifies before reporting done.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `.btrs/` paths and project structure.
2. Read `.btrs/config.json` if it exists for framework, language, tooling, and package manager.
3. Read `skills/shared/verification-protocol.md` for the self-verification process.

### Step 1: Load the task

1. If the argument is a SPEC-ID: read `.btrs/specs/SPEC-NNN-*.md`.
2. If the argument is a TODO-ID: read `.btrs/todos/TODO-NNN.md`, then follow the spec link.
3. If the argument is a description: treat it as an ad-hoc task -- still read conventions.
4. Extract: requirements, acceptance criteria, affected files, and any agent-specific instructions.

### Step 2: Read conventions and existing patterns

1. Read `.btrs/conventions/` files relevant to the domain (api.md, ui.md, database.md, testing.md).
2. Read `.btrs/code-map/` entries for the modules being modified.
3. Grep and Glob the source tree to find canonical examples of similar patterns.
4. Identify existing components, utilities, and helpers that can be reused. Do not reinvent.

### Step 3: Plan the implementation

1. List every file to be created or modified.
2. For each file, describe the changes at a high level.
3. Identify dependencies between files (write in dependency order).
4. If the plan deviates from the spec, note the deviation and the reason.
5. Present the plan to the user for confirmation before writing code.

### Step 4: Write the code

1. Follow conventions exactly -- naming, file structure, import patterns, error handling.
2. Match the style of existing code in the same module.
3. Reuse existing utilities and components. Grep before creating anything new.
4. Write clean, readable code. Prefer explicit over clever.
5. Include inline comments only where the "why" is not obvious from the code.
6. Do not introduce new dependencies without checking `.btrs/conventions/` and `package.json`.

### Step 5: Self-verify

Follow the verification protocol from `skills/shared/verification-protocol.md`:

1. **File existence** -- Confirm every file claimed to be created or modified exists and is non-empty.
2. **Pattern compliance** -- Confirm code follows conventions from `.btrs/conventions/`.
3. **Functional claims** -- For each behavior claimed, point to the code that implements it.
4. **Integration points** -- Verify all imports resolve, types are consistent, API contracts match.
5. **Completeness** -- Check every acceptance criterion from the spec.

If any check fails, fix the issue and re-verify. Do not report done with known failures.

### Step 6: Update tracking

1. If working from a TODO: update its status to `complete` in `.btrs/todos/TODO-NNN.md` (set `updated` date).
2. If working from a spec: update the spec's relevant acceptance criteria checkboxes.
3. Update `.btrs/code-map/` if new modules or significant changes were made.
4. Append to `.btrs/changelog/{today}.md` with a summary of what was implemented.

### Step 7: Write agent output

1. Write a summary to `.btrs/agents/{agent-slug}/TASK-NNN-{slug}.md` with:
   - Frontmatter (id, title, status, created, updated, tags)
   - Summary of what was built
   - List of files created and modified
   - Verification report
   - Wiki links to the parent spec and related files

### Step 8: Report completion

1. Present a summary of what was implemented.
2. Include the verification report (pass/fail/warn counts).
3. List any deferred items or known limitations.
4. Suggest next steps (tests, review, documentation).

## Anti-patterns

- **Do not ignore conventions.** Read `.btrs/conventions/` before writing any code. Convention violations will be caught by `/btrs-verify`.
- **Do not duplicate existing utilities.** Always Grep for existing helpers before writing new ones.
- **Do not skip self-verification.** Every implementation must pass the five checks before reporting done.
- **Do not introduce new dependencies silently.** Check conventions and discuss with the user first.
- **Do not write code without reading the spec first.** Even for "simple" tasks, load the full context.
- **Do not modify files outside the scope of the task.** If you find something that needs fixing, create a TODO for it instead.
- **Do not leave TODO comments in code without creating a tracked TODO in `.btrs/todos/`.** Inline TODOs get lost.
