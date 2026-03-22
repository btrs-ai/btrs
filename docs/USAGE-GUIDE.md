# BTRS Agents — Usage Guide

Everything starts with `/btrs`. This guide shows real examples of what you can ask and what happens.

---

## Quick Examples

```
/btrs build a user authentication system with Google OAuth
/btrs the checkout page shows a white screen after payment
/btrs is our API secure?
/btrs what should we build next?
/btrs deploy to production
/btrs explain how the payment flow works
```

You don't need to know which agent handles it. BTRS figures it out.

---

## Building Features

### Simple feature (single agent)

```
/btrs add a dark mode toggle to the settings page
```

What happens:
- BTRS sees this is a UI task
- Checks your conventions (existing toggle components, theme tokens)
- Dispatches **Web Engineer** with your project's patterns injected
- Agent builds it using your existing components, verifies it matches conventions
- Code-map and changelog updated

### Complex feature (multiple agents)

```
/btrs build a notification system — users should get notified when someone comments on their post
```

What happens:
- BTRS sees this crosses multiple domains
- Shows you a plan:
  ```
  1. Architect: Design notification architecture
  2. Database Engineer: Create notifications table
  3. API Engineer: Build notification endpoints + WebSocket events
  4. Web Engineer: Build notification dropdown UI
  5. QA: Write tests
  Proceed?
  ```
- You say "yes" (or modify the plan)
- Agents execute in order, each following your conventions
- Each agent verifies its work before the next one starts

### When there are multiple ways to do it

```
/btrs add real-time updates to the dashboard
```

What happens:
- BTRS recognizes this is a design decision (WebSocket? SSE? Polling?)
- Triggers `/btrs-propose` — generates 3 approaches:
  ```
  A: Polling (simple, 30 lines, uses existing fetch utility)
  B: Server-Sent Events (moderate, 80 lines, one-way stream)
  C: WebSocket (full duplex, 200 lines, new dependency)

  Recommendation: A — your dashboard updates every 30s anyway,
  and it reuses your existing API client.
  ```
- You pick one, then it builds it

---

## Fixing Bugs

```
/btrs the login form submits twice when you click the button fast
```

What happens:
- BTRS dispatches **Web Engineer** (UI bug)
- Agent reads your login form code, finds the issue
- Fixes it using your existing patterns (e.g., your existing `useDebounce` hook)
- Verifies: no duplicate submissions, existing tests still pass
- Updates code-map if the fix touched multiple files

```
/btrs users are getting 500 errors on the /api/orders endpoint
```

What happens:
- BTRS dispatches **API Engineer** (backend bug)
- Agent reads the endpoint code, error logs, schema
- Identifies root cause, fixes it
- Verifies: endpoint returns correct responses, error handling follows conventions

---

## Architecture & Planning

```
/btrs we need to add multi-tenancy to the app — plan this out
```

What happens:
- BTRS dispatches **Architect** via `/btrs-plan`
- Creates a spec at `.btrs/specs/multi-tenancy.md`
- Breaks it into tasks with agent assignments
- Creates todos in `.btrs/todos/`
- Creates an ADR at `.btrs/decisions/ADR-xxx-multi-tenancy.md`
- You review the spec, then say "implement it" to start execution

```
/btrs should we use Prisma or Drizzle for our ORM?
```

What happens:
- BTRS dispatches **Research** agent
- Evaluates both against your project's needs
- Creates a comparison in `.btrs/decisions/`
- Recommends one with clear reasoning

---

## Security

```
/btrs do a full security audit
```

What happens:
- BTRS dispatches **Code Security** and **Security Ops** in parallel
- Code Security: OWASP top 10, injection vulnerabilities, auth issues, secrets in code
- Security Ops: dependency vulnerabilities, infrastructure config, compliance
- Produces audit report in `.btrs/agents/code-security/`
- Creates todos for any findings

```
/btrs review the auth middleware for vulnerabilities
```

What happens:
- BTRS dispatches **Code Security** with scope limited to auth middleware
- Focused review with specific findings and fixes

---

## Testing

```
/btrs write tests for the notification system
```

What happens:
- BTRS dispatches **QA & Test Engineering**
- Reads your existing test patterns (jest? vitest? cypress?)
- Writes tests matching your conventions (same structure, same utilities)
- Verifies tests actually pass

```
/btrs our test coverage is low on the API layer — fix that
```

What happens:
- BTRS dispatches **QA** scoped to your API files
- Identifies uncovered endpoints and edge cases
- Writes tests following your existing test patterns

---

## DevOps & Deployment

```
/btrs set up a CI/CD pipeline for this project
```

What happens:
- BTRS dispatches **CI/CD Ops** (or **DevOps** for full workflow)
- Detects your stack, creates GitHub Actions (or equivalent)
- Includes build, test, lint, deploy stages
- Creates infrastructure docs in `.btrs/code-map/infrastructure.md`

```
/btrs deploy to production
```

What happens:
- BTRS triggers `/btrs-deploy` workflow
- Pre-deploy: runs tests, checks conventions, verifies no security issues
- Deploys using your existing deployment process
- Post-deploy: verifies health, updates changelog

```
/btrs containerize this app
```

What happens:
- BTRS dispatches **Container Ops**
- Creates Dockerfile, docker-compose.yml following best practices
- Adds to code-map and infrastructure docs

---

## Database

```
/btrs add a comments table that links to posts and users
```

What happens:
- BTRS dispatches **Database Engineer**
- Reads your existing schema (Prisma, Drizzle, raw SQL)
- Creates migration following your naming conventions
- Updates `.btrs/code-map/database-layer.md`

```
/btrs the orders query is slow — optimize it
```

What happens:
- BTRS dispatches **Database Engineer**
- Analyzes the query, suggests indexes or query restructuring
- Implements the fix, verifies improvement

---

## Documentation

```
/btrs document the API endpoints
```

What happens:
- BTRS dispatches **Documentation** agent
- Reads all API route files
- Generates docs with endpoints, request/response examples, error codes
- Updates `.btrs/code-map/api-layer.md`

```
/btrs our docs are out of date — refresh everything
```

What happens:
- BTRS triggers `/btrs-doc`
- Re-scans codebase, updates component registry, code-map
- Flags any wiki links that point to files that no longer exist

---

## Tech Debt

```
/btrs let's address tech debt
```

What happens:
- BTRS triggers `/btrs-tech-debt` — shows your current backlog prioritized
- Critical items listed first with specific fix instructions
- You pick an item (or it picks the highest priority one)
- Agent fixes it following the detailed "How to Fix" steps in the item
- Item marked resolved with evidence

```
/btrs-tech-debt scan
```

What happens:
- Deep scan across the codebase for tech debt
- Checks: code quality, dependencies, pattern violations, architecture issues, testing gaps
- Each finding becomes a detailed item in `.btrs/tech-debt/` with:
  - What's wrong (specific file and line)
  - Why it matters (impact)
  - How to fix it (step-by-step instructions)
  - Priority and effort estimate
- Items are triaged: critical (fix now) → high → medium → low

```
/btrs-tech-debt add the email service still uses callbacks instead of async/await
```

What happens:
- Creates a tech debt item with full fix details
- Scans the affected files to understand the scope
- Writes specific migration steps (callback → async/await)
- Adds to backlog with priority rating

```
/btrs-tech-debt fix TD-003
```

What happens:
- Reads the item's "How to Fix" instructions
- Follows each step, verifies the fix
- Marks the item resolved with evidence
- Updates changelog

**Proactive capture**: Agents also find tech debt during normal work. If the API engineer notices a missing index while building an endpoint, it captures a tech debt item automatically — you don't have to ask.

---

## Business & Product

```
/btrs create a product roadmap for Q2
```

What happens:
- BTRS dispatches **Product** agent
- Reviews existing specs, todos, and project state
- Creates a roadmap document with priorities and timelines

```
/btrs analyze our user signup funnel — where are we losing people?
```

What happens:
- BTRS dispatches **Data Analyst**
- Analyzes available data, creates insights
- Produces report in `.btrs/agents/data-analyst/`

```
/btrs write a marketing plan for our launch
```

What happens:
- BTRS dispatches **Marketing** agent
- Creates campaign plan, content calendar, SEO recommendations

---

## Project Health & Maintenance

```
/btrs check if everything is consistent
```

What happens:
- BTRS triggers `/btrs-health`
- Checks: convention violations, stale docs, orphaned todos, registry drift
- Reports findings, creates todos for issues

```
/btrs what's the state of the project?
```

What happens:
- BTRS reads `.btrs/` vault state
- Reports: open specs, in-progress todos, recent changes, any health issues

```
/btrs what should we work on next?
```

What happens:
- BTRS reviews open todos, spec priorities, and project state
- Recommends next tasks based on dependencies and priority

---

## Follow-Up Conversations

You only type `/btrs` once. After that, just keep talking:

```
/btrs build a user profile page

> Here's the plan: Web Engineer will build it using your
> existing UserCard and Form components. Proceed?

yes but add an avatar upload too

> Updated plan — adding avatar upload using your existing
> FileUpload component. Proceeding...

actually make the avatar circular with a border

> Updated the avatar styling. Using your rounded-full token
> and border-primary from your design system.

looks good. now write tests for it

> Dispatching QA agent scoped to the profile page...
```

No need to re-type `/btrs` for follow-ups in the same conversation.

---

## Direct Skill Access (Power Users)

If you already know exactly what you want, skip the router:

| You want... | Type... |
|-------------|---------|
| Plan a feature | `/btrs-plan user notifications` |
| Implement from a spec | `/btrs-implement specs/auth-system` |
| Review recent changes | `/btrs-review` |
| Security audit | `/btrs-audit` |
| Check conventions | `/btrs-verify src/components/` |
| Project health | `/btrs-health` |
| Refresh docs | `/btrs-doc` |
| Compare approaches | `/btrs-propose real-time updates` |
| Research a technology | `/btrs-research headless CMS options` |
| Scan for tech debt | `/btrs-tech-debt scan` |
| Fix top priority debt | `/btrs-tech-debt fix` |
| Add tech debt item | `/btrs-tech-debt add missing rate limiting` |

These all do the same thing `/btrs` would do — they just skip the classification step.

---

## Using Specific Agents Directly (Any AI Tool)

If you're not using Claude Code (or want to reference an agent manually), load the agent's instruction file as context:

**Claude Code:**
```
@agents/btrs-architect/AGENT.md
Design a microservices architecture for our e-commerce platform
```

**Cursor:**
```
@agents/btrs-api-engineer/AGENT.md
Build CRUD endpoints for the products resource
```

**Any AI (copy-paste the instructions):**
1. Open `agents/btrs-web-engineer/AGENT.md`
2. Paste it into your AI tool's system prompt or context
3. Ask your question — the AI will respond as that specialist

The agent instructions work with any AI. The skills and auto-routing are Claude Code features.

---

## Tips

- **Start broad, get specific.** "/btrs build auth" works better than trying to pick the right agent yourself.
- **Trust the conventions.** If BTRS uses your existing Button component instead of creating a new one, that's by design.
- **Check the vault.** Open `.btrs/` in Obsidian after a big feature — the graph view shows how everything connects.
- **Run /btrs-health periodically.** It catches drift before it becomes a problem.
- **Specs are your source of truth.** If you want something built a specific way, put it in a spec first with `/btrs-plan`.
