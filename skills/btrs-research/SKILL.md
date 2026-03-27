---
name: btrs-research
description: Technology evaluation, library comparison, and feasibility studies. Use when evaluating options, comparing libraries, or researching approaches.
disable-model-invocation: true
allowed-tools: Read, Write, Grep, Glob, WebSearch, WebFetch
argument-hint: <technology or question to research>
---

# /btrs-research

Technology evaluation and comparison skill. Researches options, creates comparison matrices, and produces a recommendation with an Architecture Decision Record (ADR).

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` if it exists for framework, language, and tooling context.
3. Read `btrs/decisions/` for existing ADRs that may constrain or inform the research.
4. Read `btrs/conventions/` for any rules about technology choices.
5. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
6. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

### Step 1: Define the research question

1. Parse the argument to identify the research topic.
2. Formulate a clear research question (e.g., "Which state management library best fits our React + TypeScript stack?").
3. Identify evaluation criteria based on:
   - Project constraints from `btrs/config.json`
   - Existing technology decisions from `btrs/decisions/`
   - Stated user requirements
4. List 3-5 weighted evaluation criteria. Default weights if none specified:
   - Project fit (30%) -- compatibility with existing stack
   - Community and maintenance (25%) -- active development, documentation quality
   - Performance (20%) -- benchmarks relevant to use case
   - Developer experience (15%) -- API quality, learning curve
   - Bundle size / footprint (10%) -- impact on build

### Step 2: Identify candidates

1. Based on the research question, identify 3-5 candidate solutions.
2. Include the obvious choices and at least one less-common alternative.
3. If the user specified candidates, use those.

### Step 3: Research each candidate

For each candidate, gather:

1. **Overview**: What it is, core philosophy, license.
2. **Project fit**: How well it integrates with the current stack (check `package.json`, framework, language).
3. **Adoption**: GitHub stars, npm downloads, major users.
4. **Maintenance**: Last release date, open issues, contributor count.
5. **Documentation**: Quality and completeness.
6. **Performance**: Benchmarks or known performance characteristics.
7. **Trade-offs**: Known limitations, gotchas, migration complexity.

Use WebSearch and WebFetch for external data. Use Grep and Glob to understand current project dependencies and patterns.

### Step 4: Build comparison matrix

```markdown
| Criterion (weight) | Candidate A | Candidate B | Candidate C |
|---------------------|-------------|-------------|-------------|
| Project fit (30%) | X/5 | X/5 | X/5 |
| Community (25%) | X/5 | X/5 | X/5 |
| Performance (20%) | X/5 | X/5 | X/5 |
| Dev experience (15%) | X/5 | X/5 | X/5 |
| Footprint (10%) | X/5 | X/5 | X/5 |
| **Weighted Total** | **X.XX** | **X.XX** | **X.XX** |
```

### Step 5: Produce the recommendation

Format the output as:

```markdown
# Research: {topic}

## Question
{Clear research question}

## Context
{Project constraints, existing decisions, why this research is needed}

## Candidates

### {Candidate A}
{Overview, fit, adoption, maintenance, docs, performance, trade-offs}

### {Candidate B}
...

## Comparison Matrix
{The scored table from step 4}

## Recommendation
{Which candidate and why. Reference the scores but also apply judgment for intangible factors.}

## Migration Path
{If adopting this requires changes to existing code, outline the migration steps.}

## Risks
{Known risks of the recommended option}
```

### Step 6: Write ADR

1. Scan `btrs/decisions/ADR-*.md` to find the next available ADR number.
2. Write the ADR to `btrs/decisions/ADR-NNN-{slug}.md` with:
   - Frontmatter (id, title, status: `proposed`, created, updated, tags)
   - Context section (why the decision is needed)
   - Options considered (summary of each candidate)
   - Decision (the recommendation)
   - Consequences (trade-offs accepted)
3. Set status to `proposed` -- the user must accept it.

### Step 7: Write output to vault

1. Write the full research report to `btrs/agents/research/research-{slug}.md` with proper frontmatter.
2. Update `btrs/changelog/{today}.md` with a line item about this research.
3. Present the recommendation and ADR to the user.

## Anti-patterns

- **Do not research without checking existing ADRs first.** The question may already be decided.
- **Do not rely solely on popularity metrics.** GitHub stars do not measure project fit.
- **Do not recommend a technology you cannot verify integrates with the current stack.** Check `package.json` and framework compatibility.
- **Do not present research without a clear recommendation.** The user expects a decision, not just data.
- **Do not create an ADR with status `accepted`.** Research proposes; the user or architect accepts.
- **Do not ignore the migration cost.** A technically superior option with a painful migration may not be the right choice.
