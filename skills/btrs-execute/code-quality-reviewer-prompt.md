# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable)

**Only dispatch after spec compliance review passes.**

```
Agent tool (btrs-qa-test-engineering):
  Dispatch an Agent with the btrs-qa-test-engineering agent definition
  (see agents/btrs-qa-test-engineering/AGENT.md)

  Provide:
    WHAT_WAS_IMPLEMENTED: [from implementer's report]
    PLAN_OR_REQUIREMENTS: Task N from [plan-file]
    BASE_SHA: [commit SHA before task started]
    HEAD_SHA: [current commit SHA after task completed]
    DESCRIPTION: [task summary]

  Prompt: |
    You are reviewing the code quality of a completed implementation task.

    ## What Was Implemented

    [WHAT_WAS_IMPLEMENTED]

    ## Plan / Requirements

    [PLAN_OR_REQUIREMENTS]

    ## Diff Range

    Review the changes between BASE_SHA and HEAD_SHA:
    ```
    git diff BASE_SHA..HEAD_SHA
    ```

    ## Your Job

    Perform a thorough code quality review. Assess:

    **Code Quality:**
    - Is the code clean, readable, and maintainable?
    - Are names clear and accurate?
    - Is there unnecessary complexity?
    - Are there code smells or anti-patterns?

    **SOLID Principles:**
    - Single Responsibility: Does each class/module have one reason to change?
    - Open/Closed: Is the code open for extension, closed for modification?
    - Liskov Substitution: Are subtypes substitutable for their base types?
    - Interface Segregation: Are interfaces focused and minimal?
    - Dependency Inversion: Do high-level modules depend on abstractions?

    **Test Coverage:**
    - Are tests comprehensive and meaningful?
    - Do tests verify behavior, not implementation details?
    - Are edge cases covered?
    - Was TDD discipline followed (tests written before implementation)?

    **Architecture Alignment:**
    - Does the implementation follow established patterns in the codebase?
    - Is the code consistent with the project's architecture?
    - Are dependencies appropriate?

    ## BTRS-Specific Checks

    In addition to standard code quality, verify:

    **File responsibility clarity:**
    - Does each file have one clear responsibility with a well-defined interface?
    - Can you describe what each new/modified file does in one sentence?

    **Single-purpose decomposability:**
    - Are units decomposed so they can be understood and tested independently?
    - Could a developer new to the codebase understand each unit in isolation?

    **Plan structure adherence:**
    - Is the implementation following the file structure from the plan?
    - Did the implementer deviate from the planned organization?

    **File size growth:**
    - Did this implementation create new files that are already large?
    - Did it significantly grow existing files?
    - Focus on what THIS change contributed, not pre-existing file sizes

    ## Report Format

    **Strengths:** [What was done well]

    **Issues:**
    - Critical: [Must fix before merge -- bugs, security, data loss risks]
    - Important: [Should fix -- design problems, maintainability concerns]
    - Minor: [Nice to fix -- style, naming, small improvements]

    **Assessment:** Ready | Not ready | Ready with fixes
    - Ready: No critical or important issues
    - Not ready: Critical issues that need rework
    - Ready with fixes: Important issues that should be addressed but don't require rework
```
