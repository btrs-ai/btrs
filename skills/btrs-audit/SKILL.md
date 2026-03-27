---
name: btrs-audit
description: Security and quality audit — OWASP, dependencies, secrets, compliance. Use when auditing security, checking for vulnerabilities, or compliance review.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *)
argument-hint: <scope or specific concern>
---

# /btrs-audit

Deep security and quality audit skill. Checks OWASP top 10, dependency vulnerabilities, secrets detection, and compliance requirements. Produces an audit report with severity ratings and remediation guidance.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` if it exists for framework, language, and tooling context.
3. Read `btrs/conventions/` files, especially any security-related conventions.
4. Read `btrs/decisions/` for security-related ADRs.
5. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
6. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

### Step 1: Determine audit scope

1. Parse the argument to determine what to audit:
   - Entire project: scan all source directories
   - Specific area: scan the named directory or domain
   - Specific concern: focus the audit on that concern (e.g., "authentication", "input validation")
2. List all files in scope.

### Step 2: OWASP top 10 scan

Check for each OWASP category relevant to the codebase:

1. **Injection** -- Grep for raw SQL, unsanitized template interpolation, command injection vectors.
2. **Broken authentication** -- Check token handling, session management, password storage.
3. **Sensitive data exposure** -- Check for unencrypted secrets, PII in logs, missing HTTPS enforcement.
4. **XML external entities** -- Check XML parsing configurations if applicable.
5. **Broken access control** -- Check authorization logic, missing role checks, IDOR vulnerabilities.
6. **Security misconfiguration** -- Check default credentials, debug modes, verbose errors in production.
7. **XSS** -- Check for unescaped user input in rendered output.
8. **Insecure deserialization** -- Check for unsafe JSON/object parsing.
9. **Using components with known vulnerabilities** -- Check dependency versions.
10. **Insufficient logging** -- Check that security events are logged.

### Step 3: Dependency audit

1. Read `package.json`, `package-lock.json`, `requirements.txt`, `go.mod`, or equivalent.
2. Run `npm audit` or equivalent if the package manager supports it.
3. Flag outdated dependencies with known CVEs.
4. Check for unnecessary dependencies that increase attack surface.

### Step 4: Secrets detection

1. Grep for patterns that indicate hardcoded secrets:
   - API keys, tokens, passwords in source code
   - `.env` files committed to git (check `.gitignore`)
   - Private keys or certificates in the repository
   - Connection strings with embedded credentials
2. Check that `.gitignore` covers sensitive files.
3. Check for secrets in git history if the concern warrants it (`git log --all -p` for specific patterns).

### Step 5: Compliance checks

If compliance requirements are specified (GDPR, SOC2, HIPAA, etc.):

1. Check data handling practices against the compliance framework.
2. Check for required audit logging.
3. Check data retention and deletion capabilities.
4. Check access controls and authentication requirements.
5. Note any compliance gaps.

### Step 6: Produce the audit report

Format the output with severity ratings:

```markdown
# Security Audit: {scope}

## Summary
{1-3 sentence overview with overall risk assessment}

## Severity Summary
- Critical: N findings
- High: N findings
- Medium: N findings
- Low: N findings
- Informational: N findings

## Findings

### [CRITICAL] {Finding title}
- **Location**: `file:line`
- **Category**: OWASP category or custom
- **Description**: What the vulnerability is
- **Impact**: What an attacker could do
- **Remediation**: Specific fix with code example
- **References**: Links to relevant documentation

### [HIGH] {Finding title}
...

## Dependency Report
| Package | Current | Vuln Severity | CVE | Fix Version |
|---------|---------|--------------|-----|-------------|

## Secrets Scan
- [PASS/FAIL] {check description}

## Compliance Status
| Requirement | Status | Notes |
|-------------|--------|-------|

## Recommendations
1. {Prioritized remediation steps}
```

### Step 7: Write output to vault

1. Write the audit report to `btrs/agents/{auditor-slug}/audit-{slug}.md` with proper frontmatter.
2. For each critical and high finding, create a TODO in `btrs/todos/` with priority matching severity.
3. Update `btrs/changelog/{today}.md` with a line item about this audit.

## Anti-patterns

- **Do not report false positives without qualification.** If you are unsure whether something is a vulnerability, mark it as "Informational" and explain the uncertainty.
- **Do not skip the dependency audit.** Vulnerable dependencies are one of the most common attack vectors.
- **Do not provide remediation without code examples.** A finding without a fix is only half useful.
- **Do not audit only the happy path.** Check error handling, edge cases, and failure modes.
- **Do not ignore configuration files.** Security misconfigurations in config files are as dangerous as code vulnerabilities.
- **Do not scan git history by default.** Only scan history if the user specifically requests it or if committed secrets are suspected.
