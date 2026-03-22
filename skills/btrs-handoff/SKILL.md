---
name: btrs-handoff
description: Structured context bridge between agents. Reads previous output, extracts key decisions, prepares context for the next agent. Used by the orchestrator between phases.
disable-model-invocation: true
allowed-tools: Read, Write, Grep, Glob
argument-hint: <from-agent> <to-agent> <task-context>
---

# /btrs-handoff

Structured agent-to-agent context bridge. Reads the previous agent's output, extracts key decisions and artifacts, and prepares a focused context package for the next agent. Used by the orchestrator to maintain continuity across phases.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `.btrs/` paths and project structure.
2. Read `.btrs/config.json` if it exists for project context.
3. Read `skills/shared/agent-registry.md` to validate agent slugs and understand their domains.

### Step 1: Parse the handoff parameters

1. Extract from the argument:
   - **From agent**: The agent slug whose work is complete (e.g., `architect`).
   - **To agent**: The agent slug who will receive the context (e.g., `api-engineer`).
   - **Task context**: The spec ID, TODO ID, or description connecting the two phases.
2. Validate both agent slugs against the registry.

### Step 2: Read the source agent's output

1. Glob `.btrs/agents/{from-agent}/` for recent output files.
2. If a specific task ID was provided, read that task's output file.
3. If no specific task, read the most recent output file.
4. Also read:
   - The parent spec if referenced in the output.
   - Any ADRs created or referenced by the source agent.
   - Any TODOs created by the source agent.

### Step 3: Extract key decisions

From the source agent's output, extract:

1. **Decisions made**: Technical choices, architectural patterns, tool selections.
2. **Artifacts produced**: Files created or modified, schemas defined, APIs designed.
3. **Constraints established**: Rules the next agent must follow based on upstream decisions.
4. **Open questions**: Anything the source agent flagged as unresolved.
5. **Verification status**: Pass/fail/partial from the source agent's verification report.

### Step 4: Identify what the target agent needs

Based on the target agent's domain (from the registry):

1. Filter the extracted context to what is relevant for the target agent.
2. Translate domain-specific details into the target agent's terminology.
   - Example: architect output says "use JWT with RS256" -> for api-engineer, translate to specific implementation guidance.
3. Identify which files the target agent should read before starting.
4. Identify which conventions apply to the target agent's work.

### Step 5: Build the handoff document

```markdown
# Handoff: {from-agent} -> {to-agent}

## Task Context
- **Spec**: [[specs/SPEC-NNN-{slug}]]
- **Phase**: {from-agent}'s phase -> {to-agent}'s phase
- **Date**: {today}

## Upstream Summary
{2-3 sentences summarizing what the source agent accomplished}

## Key Decisions
1. {Decision and rationale}
2. {Decision and rationale}

## Artifacts to Read
- [[agents/{from-agent}/TASK-NNN-{slug}]] -- {what it contains}
- [[decisions/ADR-NNN-{slug}]] -- {what it decided}
- `src/path/to/file.ts` -- {what was created or modified}

## Constraints for {to-agent}
1. {Constraint the target agent must respect}
2. {Constraint the target agent must respect}

## Your Assignment
{Clear description of what the target agent needs to do, written in second person}

### Files to Create or Modify
- `src/path/to/new-file.ts` -- {description}
- `src/path/to/existing-file.ts` -- {what to change}

### Acceptance Criteria (from spec)
- [ ] {relevant criteria for this agent's phase}

## Open Questions
- {Any unresolved items the target agent may need to address or escalate}

## Conventions to Follow
- Read [[conventions/{relevant}]] before starting
```

### Step 6: Write the handoff document

1. Write to `.btrs/agents/boss/handoff-{from}-to-{to}-{slug}.md` with proper frontmatter.
2. Include tags: `handoff`, source agent slug, target agent slug.
3. Update `.btrs/changelog/{today}.md` with the handoff event.

### Step 7: Present the handoff

1. Show the handoff document to the user.
2. Confirm the context is accurate and complete.
3. Provide the exact invocation command for the target agent with the handoff document as context.

## Anti-patterns

- **Do not pass the entire source agent output verbatim.** Extract and filter. The target agent needs focused context, not a wall of text.
- **Do not omit constraints.** If the architect decided on JWT with RS256, the api-engineer must know this. Missing constraints lead to rework.
- **Do not invent decisions the source agent did not make.** Only pass what was actually decided. Flag gaps as open questions.
- **Do not skip verification status.** If the source agent had partial verification, the target agent needs to know what is not yet solid.
- **Do not create a handoff without reading the source agent's actual output.** Handoffs from memory or assumption lead to drift.
- **Do not hand off to an agent that has no assignment in the spec.** Check the spec's agent assignments table first.
