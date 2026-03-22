# BTRS Agent Registry

This is the routing table for the `/btrs` skill. Use the quick match table for fast routing, then consult the detailed entries for context passing and skill selection.

## Quick Match Table

| Keywords | Agent | Skills |
|----------|-------|--------|
| architecture, design, system, ADR, scalability, patterns | `architect` | plan, propose, spec |
| test, QA, coverage, e2e, unit test, integration test, performance test | `qa-test-engineering` | implement, verify |
| docs, documentation, API docs, guide, tutorial, README | `documentation` | doc |
| research, evaluate, compare, POC, spike, innovation | `research` | research |
| API, endpoint, REST, GraphQL, backend, microservice, middleware | `api-engineer` | implement, spec |
| frontend, React, Vue, Next.js, web app, SPA, SSR, pages | `web-engineer` | implement, spec |
| mobile, React Native, Flutter, iOS, Android, app | `mobile-engineer` | implement, spec |
| desktop, Electron, Tauri, native app, menubar | `desktop-engineer` | implement, spec |
| component, UI, design system, Storybook, theme, styles, CSS | `ui-engineer` | implement, spec |
| database, schema, migration, SQL, ORM, Prisma, query, index | `database-engineer` | implement, spec |
| vulnerability, SAST, DAST, OWASP, secure code, CVE, dependency scan | `code-security` | audit, verify |
| compliance, GDPR, SOC2, HIPAA, infrastructure security, IAM, secrets | `security-ops` | audit, verify |
| cloud, AWS, Azure, GCP, infrastructure, IaC, Terraform, serverless | `cloud-ops` | deploy, implement |
| CI/CD, pipeline, GitHub Actions, deployment, release, workflow | `cicd-ops` | deploy, implement |
| Docker, Kubernetes, container, orchestration, Helm, compose | `container-ops` | deploy, implement |
| monitoring, Prometheus, Grafana, alerts, logs, observability, APM | `monitoring-ops` | implement, health |
| product, roadmap, requirements, PRD, user stories, prioritize | `product` | plan, spec |
| marketing, campaign, SEO, content, growth, social, brand | `marketing` | plan, research |
| sales, pipeline, revenue, pricing, proposal, CRM, leads | `sales` | plan, research |
| accounting, finance, invoice, budget, P&L, tax, bookkeeping | `accounting` | plan, analyze |
| customer, support, retention, NPS, onboarding, churn, feedback | `customer-success` | plan, analyze |
| analytics, BI, dashboard, metrics, KPI, data, report, visualization | `data-analyst` | analyze, research |
| coordinate, multi-agent, complex, plan, breakdown, orchestrate | `boss` | plan |

## Routing Rules

1. **Single domain** -- Route directly to the matching agent.
2. **Multi-domain** -- Route to `boss` for task breakdown and coordination.
3. **Ambiguous** -- Ask the user to clarify, suggesting the two most likely agents.
4. **No match** -- Default to `boss` for triage.

## Agent Detail

### Technical Agents

#### architect
- **Slug**: `architect`
- **Agent file**: `.claude/agents/btrs-architect.md`
- **Domain**: System design, architecture decisions, technical standards
- **Typical requests**: "Design the architecture for...", "Should we use X or Y?", "Create an ADR for..."
- **Primary skills**: `/btrs-plan`, `/btrs-propose`, `/btrs-spec`
- **Reads from**: All `.btrs/` paths (full visibility)
- **Writes to**: `.btrs/agents/architect/`, `.btrs/decisions/`

#### qa-test-engineering
- **Slug**: `qa-test-engineering`
- **Agent file**: `.claude/agents/btrs-qa-test-engineering.md`
- **Domain**: Test strategy, test writing, coverage analysis, performance testing
- **Typical requests**: "Write tests for...", "What's our test coverage?", "Create a test plan for..."
- **Primary skills**: `/btrs-implement`, `/btrs-verify`
- **Reads from**: `.btrs/specs/`, `.btrs/code-map/`, source code
- **Writes to**: `.btrs/agents/qa-test-engineering/`, test files in source

#### documentation
- **Slug**: `documentation`
- **Agent file**: `.claude/agents/btrs-documentation.md`
- **Domain**: Technical writing, API documentation, guides, tutorials
- **Typical requests**: "Document the API...", "Write a guide for...", "Update the README..."
- **Primary skills**: `/btrs-doc`
- **Reads from**: `.btrs/specs/`, `.btrs/code-map/`, source code
- **Writes to**: `.btrs/agents/documentation/`, docs in source

#### research
- **Slug**: `research`
- **Agent file**: `.claude/agents/btrs-research.md`
- **Domain**: Technology evaluation, competitive analysis, POC, spikes
- **Typical requests**: "Compare X vs Y...", "Research the best way to...", "Do a spike on..."
- **Primary skills**: `/btrs-research`
- **Reads from**: `.btrs/decisions/`, `.btrs/specs/`
- **Writes to**: `.btrs/agents/research/`

### Engineering Agents

#### api-engineer
- **Slug**: `api-engineer`
- **Agent file**: `.claude/agents/btrs-api-engineer.md`
- **Domain**: Backend APIs, REST, GraphQL, microservices, middleware
- **Typical requests**: "Build an API for...", "Add an endpoint for...", "Set up GraphQL..."
- **Primary skills**: `/btrs-implement`, `/btrs-spec`
- **Reads from**: `.btrs/specs/`, `.btrs/conventions/api.md`, `.btrs/code-map/api/`
- **Writes to**: `.btrs/agents/api-engineer/`, source code

#### web-engineer
- **Slug**: `web-engineer`
- **Agent file**: `.claude/agents/btrs-web-engineer.md`
- **Domain**: Frontend web applications, React, Vue, Next.js, SSR/SSG
- **Typical requests**: "Build a page for...", "Create the dashboard...", "Fix the frontend..."
- **Primary skills**: `/btrs-implement`, `/btrs-spec`
- **Reads from**: `.btrs/specs/`, `.btrs/conventions/ui.md`, `.btrs/code-map/web/`
- **Writes to**: `.btrs/agents/web-engineer/`, source code

#### mobile-engineer
- **Slug**: `mobile-engineer`
- **Agent file**: `.claude/agents/btrs-mobile-engineer.md`
- **Domain**: Mobile applications, React Native, Flutter, iOS, Android
- **Typical requests**: "Build the mobile app...", "Add push notifications...", "Fix the iOS bug..."
- **Primary skills**: `/btrs-implement`, `/btrs-spec`
- **Reads from**: `.btrs/specs/`, `.btrs/conventions/`, `.btrs/code-map/`
- **Writes to**: `.btrs/agents/mobile-engineer/`, source code

#### desktop-engineer
- **Slug**: `desktop-engineer`
- **Agent file**: `.claude/agents/btrs-desktop-engineer.md`
- **Domain**: Desktop applications, Electron, Tauri, native apps
- **Typical requests**: "Build the desktop app...", "Add system tray support...", "Package for Windows..."
- **Primary skills**: `/btrs-implement`, `/btrs-spec`
- **Reads from**: `.btrs/specs/`, `.btrs/conventions/`, `.btrs/code-map/`
- **Writes to**: `.btrs/agents/desktop-engineer/`, source code

#### ui-engineer
- **Slug**: `ui-engineer`
- **Agent file**: `.claude/agents/btrs-ui-engineer.md`
- **Domain**: Component libraries, design systems, Storybook, themes, CSS
- **Typical requests**: "Create a Button component...", "Set up the design system...", "Add dark mode..."
- **Primary skills**: `/btrs-implement`, `/btrs-spec`
- **Reads from**: `.btrs/specs/`, `.btrs/conventions/ui.md`, `.btrs/code-map/`
- **Writes to**: `.btrs/agents/ui-engineer/`, source code

#### database-engineer
- **Slug**: `database-engineer`
- **Agent file**: `.claude/agents/btrs-database-engineer.md`
- **Domain**: Schema design, migrations, query optimization, ORM configuration
- **Typical requests**: "Design the schema for...", "Optimize this query...", "Add a migration for..."
- **Primary skills**: `/btrs-implement`, `/btrs-spec`
- **Reads from**: `.btrs/specs/`, `.btrs/conventions/database.md`, `.btrs/decisions/`
- **Writes to**: `.btrs/agents/database-engineer/`, schema/migration files

### Security Agents

#### code-security
- **Slug**: `code-security`
- **Agent file**: `.claude/agents/btrs-code-security.md`
- **Domain**: Static analysis, vulnerability scanning, secure coding practices
- **Typical requests**: "Scan for vulnerabilities...", "Review this code for security...", "Check dependencies..."
- **Primary skills**: `/btrs-audit`, `/btrs-verify`
- **Reads from**: All source code, `.btrs/conventions/`
- **Writes to**: `.btrs/agents/code-security/`

#### security-ops
- **Slug**: `security-ops`
- **Agent file**: `.claude/agents/btrs-security-ops.md`
- **Domain**: Infrastructure security, compliance, IAM, secrets management
- **Typical requests**: "Audit GDPR compliance...", "Review IAM policies...", "Set up secrets management..."
- **Primary skills**: `/btrs-audit`, `/btrs-verify`
- **Reads from**: Infrastructure configs, `.btrs/conventions/`
- **Writes to**: `.btrs/agents/security-ops/`

### Operations Agents

#### cloud-ops
- **Slug**: `cloud-ops`
- **Agent file**: `.claude/agents/btrs-cloud-ops.md`
- **Domain**: Cloud infrastructure, IaC, serverless, networking
- **Typical requests**: "Set up AWS infrastructure...", "Write Terraform for...", "Configure the VPC..."
- **Primary skills**: `/btrs-deploy`, `/btrs-implement`
- **Reads from**: `.btrs/decisions/`, infrastructure configs
- **Writes to**: `.btrs/agents/cloud-ops/`, infrastructure files

#### cicd-ops
- **Slug**: `cicd-ops`
- **Agent file**: `.claude/agents/btrs-cicd-ops.md`
- **Domain**: CI/CD pipelines, GitHub Actions, deployment automation
- **Typical requests**: "Set up CI/CD...", "Add a deploy pipeline...", "Fix the failing build..."
- **Primary skills**: `/btrs-deploy`, `/btrs-implement`
- **Reads from**: `.btrs/decisions/`, workflow files
- **Writes to**: `.btrs/agents/cicd-ops/`, `.github/workflows/`

#### container-ops
- **Slug**: `container-ops`
- **Agent file**: `.claude/agents/btrs-container-ops.md`
- **Domain**: Docker, Kubernetes, container orchestration, Helm charts
- **Typical requests**: "Dockerize the app...", "Set up Kubernetes...", "Write a Helm chart..."
- **Primary skills**: `/btrs-deploy`, `/btrs-implement`
- **Reads from**: `.btrs/decisions/`, Docker/K8s files
- **Writes to**: `.btrs/agents/container-ops/`, container config files

#### monitoring-ops
- **Slug**: `monitoring-ops`
- **Agent file**: `.claude/agents/btrs-monitoring-ops.md`
- **Domain**: Observability, alerting, logging, APM, dashboards
- **Typical requests**: "Set up monitoring...", "Add alerting for...", "Configure logging..."
- **Primary skills**: `/btrs-implement`, `/btrs-health`
- **Reads from**: `.btrs/decisions/`, monitoring configs
- **Writes to**: `.btrs/agents/monitoring-ops/`, monitoring config files

### Business Agents

#### product
- **Slug**: `product`
- **Agent file**: `.claude/agents/btrs-product.md`
- **Domain**: Product strategy, roadmap, requirements, user stories
- **Typical requests**: "Write a PRD for...", "Prioritize the backlog...", "Define requirements for..."
- **Primary skills**: `/btrs-plan`, `/btrs-spec`
- **Reads from**: `.btrs/specs/`, `.btrs/todos/`
- **Writes to**: `.btrs/agents/product/`, `.btrs/specs/`

#### marketing
- **Slug**: `marketing`
- **Agent file**: `.claude/agents/btrs-marketing.md`
- **Domain**: Marketing strategy, campaigns, SEO, content, growth
- **Typical requests**: "Create a marketing plan...", "Write copy for...", "Analyze SEO..."
- **Primary skills**: `/btrs-plan`, `/btrs-research`
- **Reads from**: `.btrs/agents/product/`
- **Writes to**: `.btrs/agents/marketing/`

#### sales
- **Slug**: `sales`
- **Agent file**: `.claude/agents/btrs-sales.md`
- **Domain**: Sales strategy, pipeline, pricing, proposals
- **Typical requests**: "Create a pricing model...", "Write a proposal for...", "Analyze the sales pipeline..."
- **Primary skills**: `/btrs-plan`, `/btrs-research`
- **Reads from**: `.btrs/agents/product/`, `.btrs/agents/marketing/`
- **Writes to**: `.btrs/agents/sales/`

#### accounting
- **Slug**: `accounting`
- **Agent file**: `.claude/agents/btrs-accounting.md`
- **Domain**: Financial management, bookkeeping, budgets, invoicing
- **Typical requests**: "Create a budget for...", "Generate an invoice...", "Analyze expenses..."
- **Primary skills**: `/btrs-plan`, `/btrs-analyze`
- **Reads from**: Financial data, `.btrs/agents/product/`
- **Writes to**: `.btrs/agents/accounting/`

#### customer-success
- **Slug**: `customer-success`
- **Agent file**: `.claude/agents/btrs-customer-success.md`
- **Domain**: Customer retention, support, onboarding, feedback analysis
- **Typical requests**: "Analyze churn...", "Create onboarding flow...", "Review customer feedback..."
- **Primary skills**: `/btrs-plan`, `/btrs-analyze`
- **Reads from**: `.btrs/agents/product/`, customer data
- **Writes to**: `.btrs/agents/customer-success/`

#### data-analyst
- **Slug**: `data-analyst`
- **Agent file**: `.claude/agents/btrs-data-analyst.md`
- **Domain**: Business intelligence, analytics, dashboards, KPIs
- **Typical requests**: "Build a dashboard for...", "Analyze this data...", "Define KPIs for..."
- **Primary skills**: `/btrs-analyze`, `/btrs-research`
- **Reads from**: All data sources, `.btrs/agents/`
- **Writes to**: `.btrs/agents/data-analyst/`

### Management

#### boss
- **Slug**: `boss`
- **Agent file**: `.claude/agents/btrs-boss.md`
- **Domain**: Multi-agent coordination, task breakdown, complex workflows
- **Typical requests**: "Build a complete feature...", "Coordinate across teams...", any multi-domain request
- **Primary skills**: `/btrs-plan`
- **Reads from**: All `.btrs/` paths
- **Writes to**: `.btrs/agents/boss/`, `.btrs/todos/`

## Context Passing Between Agents

When routing sequential tasks, pass context using `.btrs/` paths:

```
architect writes → .btrs/decisions/ADR-005-auth.md
                   .btrs/agents/architect/TASK-001-auth-design.md
                       ↓
database-engineer reads those, writes → .btrs/agents/database-engineer/TASK-002-schema.md
                       ↓
api-engineer reads all above, writes → .btrs/agents/api-engineer/TASK-003-endpoints.md
                       ↓
code-security reads all above, writes → .btrs/agents/code-security/TASK-004-review.md
```

Always instruct agents to:
1. Read the outputs of dependent tasks before starting
2. Write their own output to their agent directory
3. Reference upstream decisions with wiki links
