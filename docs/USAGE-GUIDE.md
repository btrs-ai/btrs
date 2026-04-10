# BTRS Agents v3.0.0 — Usage Guide

Everything starts with `/btrs`. This guide shows real examples of what you can ask and what happens.

BTRS v3.0.0 consolidates skills and agents for a leaner pipeline. Every task follows a structured workflow with adaptive rigor, verification evidence, and session continuity built in.

---

## The Pipeline

Every non-trivial task flows through this pipeline:

```
/btrs → classify → brainstorm → plan → worktree → execute (TDD per task) → sanity-check → finish
```

You do not need to invoke each step manually. `/btrs` drives the pipeline automatically. For simple questions or quick lookups, BTRS skips the full pipeline and answers directly.

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

### The workflow

```
/btrs add a notification system with email and push
```

What happens:
- **Classify**: BTRS identifies this as a multi-domain feature (API + Web + possibly Mobile)
- **Brainstorm**: Explores your intent — what triggers notifications? What channels? What templates?
- **Plan**: Creates a detailed plan with tasks, agent assignments, and acceptance criteria
- **Worktree**: Creates `feature/notification-system` worktree to isolate work
- **Execute**: Each task runs through TDD — failing test first, then implementation, then refactor
- **Sanity-check**: All tests pass, linting clean, no regressions
- **Finish**: Presents options: merge to main, create PR, or continue iterating

### Simple feature (single agent)

```
/btrs add a dark mode toggle to the settings page
```

What happens:
- BTRS sees this is a UI task
- Checks your conventions (existing toggle components, theme tokens)
- Writes a failing test for the toggle behavior
- Implements using your existing components
- Verifies with evidence (test output shown)
- Code-map and changelog updated

### Complex feature (multiple agents)

```
/btrs build a notification system — users should get notified when someone comments on their post
```

What happens:
- BTRS sees this crosses multiple domains
- Brainstorms the design with you first
- Shows you a plan:
  ```
  1. Architect: Design notification architecture
  2. Database Engineer: Create notifications table
  3. API Engineer: Build notification endpoints + WebSocket events
  4. Web Engineer: Build notification dropdown UI
  5. QA: Write tests (auto-enforced via TDD on each task)
  Proceed?
  ```
- You say "yes" (or modify the plan)
- Each task executes with TDD — test first, then code
- Sanity-check runs after all tasks complete
- Finish presents merge/PR options

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
- You pick one, then it builds it through the pipeline

---

## Fixing Bugs — Systematic Debugging

```
/btrs the login form submits twice when you click the button fast
```

What happens:
- BTRS dispatches `/btrs-fix` with the 4-phase systematic process:
  1. **Observe**: Reads the login form code, identifies the double-submit behavior
  2. **Hypothesize**: Forms specific hypotheses — missing debounce, event propagation, race condition
  3. **Test**: Tests each hypothesis with evidence — adds logging, checks event handlers
  4. **Conclude**: Identifies root cause with proof, then fixes it
- Fix is implemented with TDD — regression test first, then the fix
- Evidence shown: test output proving the fix works

```
/btrs users are getting 500 errors on the /api/orders endpoint
```

What happens:
- BTRS dispatches `/btrs-fix` for the API layer
- Systematic 4-phase process: observe logs, hypothesize causes, test with specific inputs, conclude with evidence
- No guessing — every hypothesis is tested before a fix is attempted
- Regression test written first, then fix applied

---

## TDD Enforcement

Every implementation task follows Red-Green-Refactor:

```
/btrs add rate limiting to the API
```

What happens:
1. **Red**: Write a failing test — `expect(response.status).toBe(429)` when rate limit exceeded
2. **Green**: Implement minimal rate limiting middleware to make the test pass
3. **Refactor**: Clean up the implementation, extract configuration, add edge case tests
4. **Evidence**: Test output is shown — you see the actual pass/fail results

```
# TDD evidence output example:
PASS  src/middleware/__tests__/rate-limit.test.ts
  ✓ returns 429 when rate limit exceeded (12ms)
  ✓ allows requests under the limit (3ms)
  ✓ resets after the window expires (8ms)
  ✓ tracks limits per IP address (5ms)

Tests: 4 passed, 4 total
```

This is not optional. Agents cannot skip the test-first step.

---

## Session Continuity

### Starting a new session

```
/btrs
```

If there is active work, BTRS shows it:
```
Active work detected in btrs/work/:
  Feature: user-notifications (3/5 tasks complete)
  Worktree: feature/user-notifications
  Next task: Build push notification service
Resume? [Y/n]
```

Type "yes" to continue where you left off. All plan state, progress, and evidence are preserved in the `btrs/work/` directory.

### Ending a session

When you are done for the day:
```
/btrs-handoff
```

Creates a handoff document with full context so the next session (or another developer) can pick up seamlessly.

---

## Architecture & Planning

```
/btrs we need to add multi-tenancy to the app — plan this out
```

What happens:
- BTRS dispatches **Architect** via `/btrs-plan`
- Creates a spec at `btrs/knowledge/specs/multi-tenancy.md`
- Breaks it into tasks with agent assignments
- Creates an ADR at `btrs/knowledge/decisions/ADR-xxx-multi-tenancy.md`
- You review the spec, then say "implement it" to start execution through the pipeline

```
/btrs should we use Prisma or Drizzle for our ORM?
```

What happens:
- BTRS dispatches **Research** agent
- Evaluates both against your project's needs
- Creates a comparison in `btrs/knowledge/decisions/`
- Recommends one with clear reasoning

---

## Security

```
/btrs do a full security audit
```

What happens:
- BTRS dispatches **Code Security**
- OWASP top 10, injection vulnerabilities, auth issues, secrets in code
- Dependency vulnerabilities, infrastructure config, compliance
- Produces audit report in `btrs/evidence/`
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
- Verifies tests actually pass — shows evidence

```
/btrs our test coverage is low on the API layer — fix that
```

What happens:
- BTRS dispatches **QA** scoped to your API files
- Identifies uncovered endpoints and edge cases
- Writes tests following your existing test patterns
- Shows coverage before and after

---

## DevOps & Deployment

```
/btrs set up a CI/CD pipeline for this project
```

What happens:
- BTRS dispatches **DevOps**
- Detects your stack, creates GitHub Actions (or equivalent)
- Includes build, test, lint, deploy stages
- Creates infrastructure docs in `btrs/knowledge/docs/infrastructure.md`

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
- BTRS dispatches **DevOps**
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
- Updates `btrs/knowledge/docs/database-layer.md`

```
/btrs the orders query is slow — optimize it
```

What happens:
- BTRS dispatches **Database Engineer**
- Analyzes the query, suggests indexes or query restructuring
- Implements the fix, verifies improvement with evidence

---

## Documentation

```
/btrs document the API endpoints
```

What happens:
- BTRS dispatches **Documentation** agent
- Reads all API route files
- Generates docs with endpoints, request/response examples, error codes
- Updates `btrs/knowledge/docs/api-layer.md`

```
/btrs our docs are out of date — refresh everything
```

What happens:
- BTRS triggers `/btrs-doc`
- Re-scans codebase, updates component registry, code-map
- Flags any links that point to files that no longer exist

---

## Tech Debt

```
/btrs let's address tech debt
```

What happens:
- BTRS triggers `/btrs-tech-debt` — shows your current backlog prioritized
- Critical items listed first with specific fix instructions
- You pick an item (or it picks the highest priority one)
- Agent fixes it following TDD and the detailed "How to Fix" steps in the item
- Item marked resolved with evidence

```
/btrs-tech-debt scan
```

What happens:
- Deep scan across the codebase for tech debt
- Checks: code quality, dependencies, pattern violations, architecture issues, testing gaps
- Each finding becomes a detailed item in `btrs/knowledge/tech-debt/` with:
  - What's wrong (specific file and line)
  - Why it matters (impact)
  - How to fix it (step-by-step instructions)
  - Priority and effort estimate
- Items are triaged: critical (fix now) → high → medium → low

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
- Produces report with evidence

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
- BTRS reads `btrs/` vault state
- Reports: open specs, in-progress todos, active work, any health issues
- Shows session continuity status — is there active work to resume?

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
> FileUpload component. Proceeding with TDD...

actually make the avatar circular with a border

> Updated the avatar styling. Using your rounded-full token
> and border-primary from your design system.

looks good. now write tests for it

> Tests already written (TDD enforced). Here are the results:
> PASS  4/4 tests passing. See btrs/evidence/ for full output.
```

No need to re-type `/btrs` for follow-ups in the same conversation.

---

## Direct Skill Access (Power Users)

If you already know exactly what you want, skip the router:

| You want... | Type... |
|-------------|---------|
| Build a feature | `/btrs-build user notifications` |
| Fix a bug or failure | `/btrs-fix test suite fails on CI` |
| Review recent changes | `/btrs-review` |
| Research a technology | `/btrs-research headless CMS options` |
| Dispatch a specific agent | `/btrs-dispatch web-engineer` |
| Route automatically | `/btrs add real-time updates` |

These all do the same thing `/btrs` would do — they just skip the classification step.

---

## The btrs/ Directory (Three-Tier Structure)

```
btrs/
  knowledge/              # Persistent project knowledge
    conventions/           # Auto-detected project patterns
    decisions/             # ADRs and design decisions
    docs/                  # Auto-generated documentation
    tech-debt/             # Tech debt backlog items
  work/                   # Active session state
    current-plan.md        # Active implementation plan
    progress.md            # Task completion tracking
    handoff.md             # Session continuity context
  evidence/               # Verification proof
    test-results.md        # Test output evidence
    review-log.md          # Code review records
    sanity-check.md        # Pre-merge verification
```

- **knowledge/** persists across sessions. Conventions, decisions, and documentation accumulate here.
- **work/** tracks the current task. This is how session continuity works — `/btrs` reads this on startup.
- **evidence/** stores proof of verification. Every claim of "it works" has evidence here.

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

The agent instructions work with any AI. The skills, pipeline, and auto-routing are Claude Code features.

---

## Tips

- **Start broad, get specific.** "/btrs build auth" works better than trying to pick the right agent yourself.
- **Trust the pipeline.** TDD, verification, and sanity-checks are automatic. You do not need to ask for them.
- **Check the evidence.** Open `btrs/evidence/` after any task to see actual test output and verification proof.
- **Session continuity is automatic.** Just type `/btrs` in a new session — it shows active work if any exists.
- **Run /btrs-health periodically.** It catches drift before it becomes a problem.
- **Plans are your source of truth.** If you want something built a specific way, shape it during the brainstorm phase.
- **Debugging is systematic.** Do not guess — `/btrs-fix` follows the 4-phase process every time.
