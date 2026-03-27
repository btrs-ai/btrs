---
name: btrs-propose
description: Generate 3 solution approaches, evaluate against project criteria, and recommend the best one. Use when facing design decisions, architecture choices, or multiple valid implementation paths.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Grep, Glob
argument-hint: <problem or decision to explore>
---

# /btrs-propose

Multi-solution exploration skill. Generates three approaches (minimal, conventional, scalable), evaluates each against weighted project criteria, and presents a recommendation with rationale.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` if it exists for framework, language, and tooling context.
3. Read `btrs/conventions/` files relevant to the problem domain (ui.md, api.md, database.md, etc.).
4. Read `btrs/decisions/` for prior ADRs that constrain the solution space.
5. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
6. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

### Step 1: Clarify the problem

1. Parse the user's argument to identify the decision or problem.
2. If the problem is ambiguous, ask one round of clarifying questions -- no more.
3. Identify the domain(s) involved (frontend, backend, infra, business, etc.).
4. List any hard constraints (existing tech stack, budget, timeline, compliance).

### Step 2: Generate three approaches

Generate three distinct approaches in parallel. Each must be genuinely different, not minor variations of the same idea.

**Approach A -- Minimal**
- Least effort, smallest scope
- Optimizes for shipping speed
- Acceptable trade-offs documented

**Approach B -- Conventional**
- Follows established patterns and industry norms
- Balances effort and quality
- Most teams would pick this by default

**Approach C -- Scalable**
- Built for growth and future requirements
- Higher upfront cost, lower long-term cost
- Optimizes for extensibility and maintainability

For each approach, document:
- Summary (2-3 sentences)
- Key technical decisions
- Files affected (new and modified)
- Estimated complexity (low / medium / high)
- Trade-offs and risks
- Which project conventions it follows or bends

### Step 3: Evaluate against weighted criteria

Score each approach (1-5) against these criteria:

| Criterion | Weight | Description |
|-----------|--------|-------------|
| Convention compliance | 30% | Follows `btrs/conventions/` and existing codebase patterns |
| Reuse | 25% | Leverages existing components, utilities, and infrastructure |
| Simplicity | 20% | Easy to understand, review, and debug |
| Maintainability | 15% | Easy to modify, extend, and test over time |
| Completeness | 10% | Covers all stated requirements without gaps |

Calculate weighted scores: `(score * weight)` summed across all criteria.

### Step 4: Present recommendation

Format the output as:

```markdown
# Proposal: {problem title}

## Problem Statement
{1-2 sentences}

## Constraints
- {list hard constraints}

## Approach A: Minimal
{summary, decisions, files, complexity, trade-offs}

## Approach B: Conventional
{summary, decisions, files, complexity, trade-offs}

## Approach C: Scalable
{summary, decisions, files, complexity, trade-offs}

## Evaluation Matrix

| Criterion (weight) | A: Minimal | B: Conventional | C: Scalable |
|---------------------|-----------|-----------------|-------------|
| Convention compliance (30%) | X/5 | X/5 | X/5 |
| Reuse (25%) | X/5 | X/5 | X/5 |
| Simplicity (20%) | X/5 | X/5 | X/5 |
| Maintainability (15%) | X/5 | X/5 | X/5 |
| Completeness (10%) | X/5 | X/5 | X/5 |
| **Weighted Total** | **X.XX** | **X.XX** | **X.XX** |

## Recommendation
{Which approach and why. Reference the scores but also apply judgment.}

## Next Steps
{What to do after the user picks an approach -- e.g., create a spec, write an ADR, start implementation.}
```

### Step 5: Write output to vault

1. Write the proposal to `btrs/agents/{requesting-agent-or-boss}/proposal-{slug}.md` with proper frontmatter.
2. Include wiki links to any referenced conventions, ADRs, or specs.
3. Update `btrs/changelog/{today}.md` with a line item about this proposal.

## Anti-patterns

- **Do not generate three variations of the same idea.** Each approach must take a fundamentally different path.
- **Do not skip the evaluation matrix.** Even if the answer seems obvious, score all three.
- **Do not invent requirements.** Score only against what was stated and what conventions demand.
- **Do not recommend the scalable approach by default.** Minimal or conventional are often the right call. Let the scores decide.
- **Do not write code in this skill.** Proposals are design artifacts, not implementations. Use `/btrs-implement` after approval.
- **Do not ignore existing ADRs.** If a prior decision constrains the solution, respect it or explicitly propose overriding it.
