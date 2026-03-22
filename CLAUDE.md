# BTRS Agents -- Claude Code Instructions

See **AGENTS.md** for the full BTRS instruction set. This file adds Claude Code-specific features.

## Entry Point

Use `/btrs` as the primary entry point. It routes to the correct skill automatically.
For direct access, use any of the 16 skills: `/btrs-init`, `/btrs-plan`, `/btrs-propose`,
`/btrs-implement`, `/btrs-review`, `/btrs-audit`, `/btrs-verify`, `/btrs-health`, `/btrs-deploy`,
`/btrs-research`, `/btrs-analyze`, `/btrs-spec`, `/btrs-handoff`, `/btrs-doc`, `/btrs-tech-debt`.

## Plan Mode (Default)

All requests default to plan mode. Create a task breakdown, show it, and wait for
explicit user approval before executing. See AGENTS.md for the full protocol.

## Dispatching Specialist Agents

Use the Agent tool (subagent) to dispatch work to specialists. Each agent is defined
in `agents/btrs-*/AGENT.md`. Available subagent types:

| subagent_type | Agent |
|---------------|-------|
| `btrs-boss` | Orchestrator, task coordination |
| `btrs-architect` | System design, ADRs |
| `btrs-api-engineer` | Backend APIs, REST, GraphQL |
| `btrs-web-engineer` | React, Vue, frontend apps |
| `btrs-mobile-engineer` | React Native, Flutter, mobile |
| `btrs-desktop-engineer` | Electron, Tauri, desktop apps |
| `btrs-ui-engineer` | Component libraries, design systems |
| `btrs-database-engineer` | Schema, migrations, optimization |
| `btrs-qa-test-engineering` | Testing (unit, integration, e2e) |
| `btrs-code-security` | SAST/DAST, vulnerability scanning |
| `btrs-security-ops` | Infrastructure security, compliance |
| `btrs-cloud-ops` | AWS, Azure, GCP infrastructure |
| `btrs-cicd-ops` | Pipelines, GitHub Actions |
| `btrs-container-ops` | Docker, Kubernetes |
| `btrs-monitoring-ops` | Prometheus, Grafana, observability |
| `btrs-documentation` | Technical writing, API docs |
| `btrs-research` | Tech evaluation, POCs |
| `btrs-product` | Product strategy, roadmap |
| `btrs-marketing` | Campaigns, growth, SEO |
| `btrs-sales` | Pipeline, revenue, BD |
| `btrs-accounting` | Financials, bookkeeping |
| `btrs-customer-success` | Retention, support |
| `btrs-data-analyst` | BI, analytics, dashboards |
| `btrs-devops` | General DevOps workflows |

## Memory Context

When dispatching agents, pass relevant context from `AI/memory/` and instruct
agents to write their output back to their memory location. See AGENTS.md for
the full memory system layout.

## Additional Resources

- **Full Instructions**: `AGENTS.md`
- **Quick Start Guide**: `docs/getting-started/QUICK-START-CLAUDE-CODE.md`
- **Detailed Workflows**: `docs/getting-started/CLAUDE-CODE-USAGE.md`
- **All Agent Definitions**: `agents/btrs-*/AGENT.md`
- **Plugin Manifest**: `plugin.json`
