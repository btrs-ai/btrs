---
name: dispatch
description: >
  Direct agent dispatch for power users. Sends a task directly to a named
  specialist agent with conventions and protocols injected. Use when you know
  exactly which agent you need.
disable-model-invocation: true
allowed-tools: Agent, Read, Grep, Glob, Bash(git *)
argument-hint: <agent-name> <task description>
---

# BTRS Dispatch — Direct Agent Access

Power user shortcut to dispatch a specific agent with full protocol injection.

The user's request is: $ARGUMENTS

## Step 0: Parse request

1. Extract the agent name from `$ARGUMENTS`. Accept any of:
   - Full name: `btrs-api-engineer`
   - Short name: `api-engineer`
   - Slug: `api`
2. Extract the task description (everything after the agent name).
3. If no agent name is recognized, show available agents and ask.

## Step 1: Load context

1. Read `btrs/config.json` if it exists.
2. Read `skills/shared/rigor-protocol.md` to determine rigor level.
3. Read `btrs/conventions/patterns.md` and `btrs/conventions/registry.md` if they exist.
4. Read `btrs/conventions/anti-patterns.md` if it exists.
5. Read `btrs/project-map.md` for the agent's file scope.

## Step 2: Resolve agent

### Tier 1 — Active agents (always available)

| Short name | Full agent | Domain |
|------------|-----------|--------|
| `boss` | btrs-boss | Multi-agent coordination |
| `architect` | btrs-architect | System design, ADRs |
| `api` | btrs-api-engineer | Backend APIs, REST, GraphQL |
| `web` | btrs-web-engineer | Frontend, React, Vue, Next.js |
| `mobile` | btrs-mobile-engineer | Mobile apps, React Native, Flutter |
| `ui` | btrs-ui-engineer | Components, design systems |
| `db`, `database` | btrs-database-engineer | Schema, migrations, queries |
| `qa`, `test` | btrs-qa-test-engineering | Testing, coverage |
| `security` | btrs-code-security | Vulnerability scanning, secure code |
| `devops` | btrs-devops | Cloud, CI/CD, containers, monitoring |
| `research` | btrs-research | Tech evaluation, comparison |
| `docs` | btrs-documentation | Technical writing |

### Tier 2 — On-demand agents (available but not preloaded)

| Short name | Full agent | Domain |
|------------|-----------|--------|
| `desktop` | btrs-desktop-engineer | Electron, Tauri, native desktop |
| `secops` | btrs-security-ops | Infrastructure security, compliance |
| `cloud` | btrs-cloud-ops | Deep cloud infrastructure |
| `cicd` | btrs-cicd-ops | Deep CI/CD pipelines |
| `containers` | btrs-container-ops | Deep Kubernetes, Docker |
| `monitoring` | btrs-monitoring-ops | Deep observability |
| `product` | btrs-product | Product strategy, roadmap |
| `marketing` | btrs-marketing | Marketing, SEO, content |
| `sales` | btrs-sales | Sales strategy, pipeline |
| `accounting` | btrs-accounting | Finance, bookkeeping |
| `cs` | btrs-customer-success | Customer retention, support |
| `data` | btrs-data-analyst | BI, analytics, dashboards |

## Step 3: Dispatch

Invoke the Agent tool with:

```
TASK: {task description from user}

RIGOR: {quick|standard|strict} — {why}

YOUR SCOPE:
  Primary: {file patterns from project-map.md}
  Do NOT modify: {paths outside scope}

CONVENTIONS:
  {Paste relevant convention content inline}

  Existing components (do NOT recreate):
  {Relevant excerpt from registry.md}

  Anti-patterns to avoid:
  {Relevant anti-patterns}

VERIFICATION:
  {Based on rigor level}
```

Announce the dispatch:
```
Dispatching {agent-name} to {task summary}
  Rigor: {level}
  Scope: {primary file patterns}
```

## Step 4: Report results

After the agent returns:
1. Present the agent's output to the user.
2. Note any verification results.
3. Update `btrs/status.md` if this was tracked work.

## Anti-Patterns

- Do not dispatch without loading conventions first.
- Do not give agents broad scope ("fix everything").
- Do not dispatch multiple agents here — use `/build` for coordinated multi-agent work.
