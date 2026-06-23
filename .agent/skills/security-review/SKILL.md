---
name: security-review
description: Comprehensive security checklist and patterns for authentication, input handling, secrets, API endpoints, and sensitive features.
triggers:
  keywords:
    primary: [security, authentication, authorization, vulnerability]
    secondary: [xss, csrf, sql injection, rate limiting, secrets]
  context_boost: [api endpoint, user input, file upload, payment, credentials]
  context_penalty: [styling, css, ui layout, documentation]
  priority: high
---

# Security Review Skill

Security best practices checklist and vulnerability prevention patterns.

## When to Activate

- Implementing authentication or authorization
- Handling user input or file uploads
- Creating new API endpoints
- Working with secrets or credentials
- Implementing payment features
- Storing or transmitting sensitive data
- Integrating third-party APIs

## References

| Topic | Description | File |
|-------|-------------|------|
| Secrets & Input Validation | Environment variables, Zod schemas, file upload validation | [secrets-input-validation.md](references/secrets-input-validation.md) |
| SQL Injection & Auth | Parameterized queries, JWT handling, RLS, authorization checks | [sql-injection-auth.md](references/sql-injection-auth.md) |
| XSS, CSRF & Rate Limiting | DOMPurify, CSP headers, CSRF tokens, express-rate-limit | [xss-csrf-ratelimit.md](references/xss-csrf-ratelimit.md) |
| Sensitive Data & Blockchain | Log redaction, error messages, wallet/transaction verification | [sensitive-data-blockchain.md](references/sensitive-data-blockchain.md) |
| Dependencies, Testing & Checklist | npm audit, security tests, pre-deployment checklist | [dependencies-testing-checklist.md](references/dependencies-testing-checklist.md) |
