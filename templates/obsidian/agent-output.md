---
id: "{{task-id}}"
title: "{{title}}"
agent: "{{agent}}"
status: complete
created: {{date}}
updated: {{date}}
spec: ""
todo: ""
tags: []
---

# {{task-id}}: {{title}}

## Task summary

<!-- What was the task and what was accomplished? -->

**Assigned by**: [[specs/{{spec}}]] | [[todos/{{todo}}]]
**Agent**: {{agent}}

## Work performed

<!-- Describe what was done. Be specific about decisions made during implementation. -->

### Changes made

| File | Action | Description |
|------|--------|-------------|
| `path/to/file.ts` | Created | Description of what it does |
| `path/to/other.ts` | Modified | What was changed and why |

### Key decisions

<!-- Any decisions made during implementation that deviated from or refined the spec. -->

1.

### Dependencies introduced

<!-- New packages, services, or integrations added. -->

-

## Claims

<!-- List every functional claim this output makes. These will be verified. -->

1.
2.
3.

## Verification report

**Verified by**: {{agent}}
**Date**: {{date}}
**Overall status**: PASS | PARTIAL | FAIL

### Summary

- Total checks: 0
- Passed: 0
- Failed: 0
- Warnings: 0
- Manual: 0
- Skipped: 0

### File existence

<!-- Verify every file mentioned above exists. -->

- [PASS | FAIL] `path/to/file.ts` -- exists, N lines

### Pattern compliance

<!-- Verify code follows project conventions. -->

- [PASS | WARN | FAIL] Description of check

### Functional claims

<!-- Verify each claim from the Claims section. -->

- [PASS | FAIL | MANUAL] Claim description -- how verified

### Integration points

<!-- Verify imports, API calls, types across boundaries. -->

- [PASS | FAIL] Description of integration check

### Completeness

<!-- Check each requirement from the spec/todo is addressed. -->

- [PASS | FAIL | SKIP] Requirement -- status

### Failures and remediation

<!-- For each FAIL, describe the issue and what is needed to fix it. Remove this section if all checks passed. -->

## Handoff notes

<!-- Information the next agent or the user needs to know. -->

-

## Related files

- Spec: [[specs/{{spec}}]]
- Todo: [[todos/{{todo}}]]
- Upstream: [[agents/{{upstream-agent}}/{{upstream-task}}]]
