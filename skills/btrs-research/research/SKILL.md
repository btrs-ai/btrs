---
name: research
description: >
  Technology evaluation, brainstorming, analysis, and comparison. Use for
  evaluating options, comparing libraries, researching approaches, brainstorming
  ideas, or analyzing data/code. Auto-detects mode from context.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Grep, Glob, WebSearch, WebFetch, Bash(git *)
argument-hint: <technology, question, or topic to research>
---

# Research, Brainstorm & Analyze

Auto-detects the research mode:
- **Evaluate**: "compare Prisma vs Drizzle", "which state management library?"
- **Brainstorm**: "how should we approach X?", "explore ideas for Y"
- **Analyze**: "analyze our API performance", "review this data"

The user's request is: $ARGUMENTS

## Step 0: Load context

1. Read `btrs/config.json` if it exists.
2. Read `btrs/decisions/` for existing ADRs that constrain or inform the research.
3. Read `btrs/conventions/patterns.md` if it exists for current technology choices.

## Step 1: Detect mode and define the question

**Mode detection:**
- Keywords "compare", "vs", "which", "evaluate", "choose" → **Evaluate**
- Keywords "brainstorm", "explore", "how should we", "what approach", "ideas" → **Brainstorm**
- Keywords "analyze", "review", "assess", "examine", "investigate" → **Analyze**

Formulate a clear research question.

## Evaluate Mode

### Step 2: Identify candidates

1. Identify 3-5 candidate solutions.
2. Include obvious choices and at least one less-common alternative.
3. If user specified candidates, use those.

### Step 3: Research each candidate

For each, gather:
- **Overview**: What it is, core philosophy, license.
- **Project fit**: Integration with current stack (check `package.json`, framework).
- **Adoption**: GitHub stars, npm downloads, major users.
- **Maintenance**: Last release date, open issues, contributor count.
- **Performance**: Benchmarks or known characteristics.
- **Trade-offs**: Limitations, gotchas, migration complexity.

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

### Step 5: Recommend and write ADR

1. Present recommendation with reasoning.
2. Write ADR to `btrs/decisions/ADR-NNN-{slug}.md` with status `proposed`.
3. Present to user for approval.

## Brainstorm Mode

### Step 2: Explore context

1. Scan existing specs, decisions, and recent git history.
2. Understand what already exists.

### Step 3: Understand the idea

Ask clarifying questions — one at a time, multiple choice when possible:
1. Purpose — What problem does this solve?
2. Constraints — What must it work with?
3. Scope — Included vs excluded?
4. Success criteria — How do we know it works?

### Step 4: Propose approaches

Present 2-3 approaches with trade-offs. Lead with recommended. Let user pick.

### Step 5: Present design

Scale detail to complexity. Check with user after each section:
1. Architecture — High-level structure.
2. Components — New vs modified.
3. Data flow.
4. Agent assignments.

### Step 6: Hand off

Once user approves, invoke `/build` to continue with spec writing and implementation.

## Analyze Mode

### Step 2: Gather data

1. Read relevant code, logs, metrics, or data files.
2. Grep for patterns, counts, and anomalies.
3. Use WebSearch/WebFetch for external context if needed.

### Step 3: Analyze

1. Identify patterns, trends, and outliers.
2. Compare against baselines or expectations.
3. Note root causes where visible.

### Step 4: Report

Present findings with:
- Summary of what was analyzed
- Key findings (ranked by impact)
- Actionable recommendations
- Data supporting each finding

## Anti-Patterns

- Do not research without checking existing ADRs first.
- Do not recommend without a clear rationale.
- Do not skip the comparison matrix in evaluate mode.
- Do not present only one approach in brainstorm mode.
- Do not create an ADR with status `accepted` — research proposes, user accepts.
