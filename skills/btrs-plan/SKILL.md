---
name: btrs-plan
description: Create a structured feature spec with requirements, acceptance criteria, and agent assignments. Use when planning a feature, designing a system, or scoping work.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: <feature or system to plan>
---

# /btrs-plan

Structured spec creation skill. Reads project conventions, creates a spec from the standard template, identifies affected files, assigns agents, and creates todo items for tracking.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `.btrs/` paths and project structure.
2. Read `.btrs/config.json` if it exists for framework, language, and tooling context.
3. Read `skills/shared/spec-format.md` for the canonical spec template.
4. Read `skills/shared/agent-registry.md` for available agents and their domains.
5. Read `.btrs/conventions/` files relevant to the planned feature.
6. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
7. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

### Step 1: Understand the scope

1. Parse the user's argument to identify what needs to be planned.
2. Read existing specs in `.btrs/specs/` to check for overlap or dependencies.
3. Read existing ADRs in `.btrs/decisions/` for architectural constraints.
4. If the scope is too large for a single spec, propose splitting into multiple specs and confirm with the user.

### Step 2: Assign the next spec ID

1. Glob `.btrs/specs/SPEC-*.md` to find existing spec files.
2. Extract the highest SPEC number.
3. Increment by 1 and zero-pad to 3 digits (e.g., `SPEC-004`).

### Step 3: Identify affected files

1. Based on the feature description, identify which source files will be created or modified.
2. Use Grep and Glob to confirm existing files and their current state.
3. Categorize as "New Files" and "Modified Files" with brief descriptions of changes.

### Step 4: Assign agents

1. Map each task area to the appropriate agent from the registry.
2. Identify dependencies between agent tasks (e.g., database-engineer before api-engineer).
3. Set priority for each assignment (low / medium / high / critical).

### Step 5: Write the spec

1. Use the full spec template from `skills/shared/spec-format.md`.
2. Fill in all sections: summary, background, requirements, user stories, technical design, affected files, agent assignments, acceptance criteria, out of scope, open questions.
3. Write the spec to `.btrs/specs/SPEC-NNN-{slug}.md` with proper YAML frontmatter.
4. Set status to `draft`.
5. Use wiki links to reference related specs, ADRs, and conventions.

### Step 6: Create todo items

1. For each agent assignment in the spec, create a corresponding TODO file in `.btrs/todos/`.
2. Scan `.btrs/todos/TODO-*.md` to find the next available TODO number.
3. Each TODO must include:
   - Frontmatter with id, title, status (`pending`), priority, created, updated, tags
   - Reference back to the parent spec via wiki link
   - Clear description of what the agent should do
   - Acceptance criteria pulled from the spec

### Step 7: Update the changelog

1. Append to `.btrs/changelog/{today}.md` (create if it does not exist).
2. Add a line item: `- Created [[specs/SPEC-NNN-{slug}]] with N tasks assigned to N agents`.

### Step 8: Present the plan

1. Show the user the complete spec.
2. List all created TODOs with their agent assignments.
3. Show the recommended execution order.
4. Ask for approval to change status from `draft` to `in-progress`.

## Anti-patterns

- **Do not write vague acceptance criteria.** "It should work well" is not a criterion. Every criterion must be testable.
- **Do not skip the affected files section.** This is the most useful section for implementation agents.
- **Do not create a spec without checking for existing overlapping specs.** Duplicate specs cause confusion.
- **Do not assign agents that do not exist in the registry.** Use only registered agent slugs.
- **Do not create TODOs without linking back to the parent spec.** Orphaned TODOs lose context.
- **Do not plan implementation details for other agents.** Describe what needs to be done, not how. The assigned agent decides how.
- **Do not leave the "Out of scope" section empty.** Explicitly defining boundaries prevents scope creep.
