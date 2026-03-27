---
name: btrs-analyze
description: Data analysis, metrics, reporting, and business intelligence. Use when analyzing data, creating reports, or measuring performance.
disable-model-invocation: true
allowed-tools: Read, Write, Grep, Glob, Bash(*)
argument-hint: <what to analyze>
---

# /btrs-analyze

Data and business analysis skill. Analyzes metrics, generates reports, builds dashboards, and produces business intelligence outputs.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` if it exists for project context.
3. Read `btrs/agents/data-analyst/` for prior analysis outputs.
4. Read `btrs/agents/product/` for product context if doing business analysis.
5. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
6. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

### Step 1: Define the analysis

1. Parse the argument to identify what needs to be analyzed.
2. Categorize the analysis type:
   - **Code metrics**: Lines of code, complexity, test coverage, dependency counts
   - **Project metrics**: Spec completion rates, TODO velocity, convention compliance trends
   - **Business metrics**: Revenue, growth, churn, NPS, funnel analysis
   - **Performance metrics**: Build times, response times, error rates
   - **Custom**: User-defined analysis
3. Identify data sources:
   - Source code and git history
   - `btrs/` vault files (specs, todos, changelog)
   - External data files (CSV, JSON, database exports)
   - API responses

### Step 2: Gather data

1. For code metrics: use Grep, Glob, and Bash to scan the codebase.
   - `git log --shortstat` for commit history
   - `wc -l` for line counts
   - Glob for file counts by type
2. For project metrics: read `btrs/` files.
   - Count specs by status
   - Count TODOs by status and age
   - Read changelog for activity patterns
3. For business/external data: read provided data files or use Bash to process them.

### Step 3: Process and compute

1. Calculate the relevant metrics.
2. Compute trends where historical data is available (compare against prior reports in `btrs/agents/data-analyst/`).
3. Identify outliers, anomalies, or notable patterns.
4. Compute summary statistics (totals, averages, medians, percentiles as appropriate).

### Step 4: Generate insights

1. Translate raw numbers into actionable insights.
2. For each metric, answer: "So what? What should we do about this?"
3. Identify correlations between metrics if multiple data points are available.
4. Flag any concerning trends early.

### Step 5: Produce the report

```markdown
# Analysis: {topic}

## Summary
{2-3 sentence executive summary with key findings}

## Key Metrics

| Metric | Value | Trend | Status |
|--------|-------|-------|--------|
| {name} | {value} | {up/down/stable} | {good/warning/critical} |

## Detailed Findings

### {Finding 1}
{Description, data, visualization (markdown table or ASCII chart), interpretation}

### {Finding 2}
...

## Trends
{How metrics have changed over time, referencing prior reports if available}

## Insights
1. {Actionable insight}
2. {Actionable insight}

## Recommendations
1. {What to do based on the data}
2. {What to monitor going forward}

## Data Sources
- {List all data sources used}

## Methodology
- {Briefly describe how metrics were calculated for reproducibility}
```

### Step 6: Write output to vault

1. Write the report to `btrs/agents/data-analyst/analysis-{slug}.md` with proper frontmatter.
2. Include tags for the analysis type and domain.
3. Use wiki links to reference related specs, TODOs, or decisions.
4. Update `btrs/changelog/{today}.md` with a line item about this analysis.

## Anti-patterns

- **Do not present raw data without interpretation.** Numbers without context are not analysis.
- **Do not fabricate data.** If a metric cannot be measured, say so. Do not estimate without labeling it as an estimate.
- **Do not ignore methodology.** Document how metrics were calculated so they can be reproduced.
- **Do not analyze without a clear question.** Every analysis should answer a specific question or set of questions.
- **Do not skip the trend comparison.** A single data point is a fact, not an insight. Trends tell the story.
- **Do not make business recommendations from code metrics alone.** Code quality and business success are related but not equivalent.
