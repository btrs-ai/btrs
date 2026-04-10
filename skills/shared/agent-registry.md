# BTRS Agent Registry

Routing table for the `/btrs` and `/dispatch` skills. Tier 1 agents are always loaded. Tier 2 agents are available on demand via `/dispatch`.

## Quick Match Table

### Tier 1 — Active Agents

| Keywords | Agent | Domain |
|----------|-------|--------|
| architecture, design, system, ADR, scalability, patterns | `architect` | System design, ADRs |
| API, endpoint, REST, GraphQL, backend, microservice, middleware | `api-engineer` | Backend APIs |
| frontend, React, Vue, Next.js, web app, SPA, SSR, pages | `web-engineer` | Frontend web |
| mobile, React Native, Flutter, iOS, Android, app | `mobile-engineer` | Mobile apps |
| component, UI, design system, Storybook, theme, styles, CSS | `ui-engineer` | UI components |
| database, schema, migration, SQL, ORM, Prisma, query, index | `database-engineer` | Database |
| test, QA, coverage, e2e, unit test, integration test | `qa-test-engineering` | Testing |
| vulnerability, SAST, DAST, OWASP, secure code, CVE | `code-security` | App security |
| cloud, AWS, CI/CD, Docker, K8s, deploy, infrastructure, monitoring | `devops` | All ops domains |
| research, evaluate, compare, POC, spike, innovation | `research` | Tech evaluation |
| docs, documentation, API docs, guide, tutorial, README | `documentation` | Technical writing |
| coordinate, multi-agent, complex, plan, breakdown, orchestrate | `boss` | Coordination |

### Tier 2 — On-Demand Agents

Available via `/dispatch`. Not loaded by default.

| Keywords | Agent | Domain |
|----------|-------|--------|
| desktop, Electron, Tauri, native app | `desktop-engineer` | Desktop apps |
| compliance, GDPR, SOC2, HIPAA, IAM, secrets | `security-ops` | Infra security |
| cloud, AWS, Azure, GCP, Terraform, IaC | `cloud-ops` | Deep cloud |
| pipeline, GitHub Actions, Jenkins | `cicd-ops` | Deep CI/CD |
| Kubernetes, container, Helm, compose | `container-ops` | Deep containers |
| Prometheus, Grafana, alerts, logs, APM | `monitoring-ops` | Deep observability |
| product, roadmap, requirements, PRD, user stories | `product` | Product mgmt |
| marketing, campaign, SEO, content, growth | `marketing` | Marketing |
| sales, pipeline, revenue, pricing, CRM | `sales` | Sales |
| accounting, finance, invoice, budget, P&L | `accounting` | Finance |
| customer, support, retention, NPS, onboarding | `customer-success` | Customer success |
| analytics, BI, dashboard, metrics, KPI, data | `data-analyst` | Analytics |

## Routing Rules

1. **Single domain** — Route directly to the matching agent.
2. **Multi-domain** — Route to `boss` for coordination.
3. **Ops keywords** — Route to `devops` first. It delegates to specialized ops agents for deep dives.
4. **Ambiguous** — Ask the user to clarify, suggesting the two most likely agents.
5. **No match** — Default to `boss` for triage.

## Context Passing Between Agents

When routing sequential tasks, pass context using `btrs/` paths:

```
architect writes → btrs/decisions/ADR-005-auth.md
                       ↓
database-engineer reads those, writes → schema changes
                       ↓
api-engineer reads all above, writes → endpoint implementation
                       ↓
code-security reads all above, writes → security review
```

Always instruct agents to:
1. Read outputs of dependent tasks before starting
2. Reference upstream decisions
3. Write their outputs to appropriate `btrs/` paths
