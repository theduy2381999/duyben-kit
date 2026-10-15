---
name: code-review
description: Review code against the team checklist. Use when the user asks to review code, check a PR, look over changes, or before committing or merging.
---

# Code Review

## Process

1. Determine the review scope:
   - Uncommitted changes: `git diff HEAD`
   - A branch: `git diff main...HEAD`
   - Specific files or a PR named by the user: review exactly that scope
2. Read enough surrounding context for each change (callers, types, related tests) before drawing conclusions.
3. Go through the checklist below.
4. Report using the template at the end of this file.

## Checklist

**Correctness**
- Are edge cases handled (empty, null, negative values, large lists)?
- Are errors handled or propagated clearly, never silently swallowed?
- Any race conditions or leaked resources (files, connections, listeners)?

**Security**
- Is external input validated before use?
- Are secrets, tokens or passwords exposed in code or logs?
- Any injection risk (SQL, shell, HTML)?

**Maintainability**
- Do variable and function names state their purpose?
- Is there duplicated code that should reuse an existing function?
- Is a function too long or doing too many things?

**Tests**
- Do logic changes come with tests?
- Do the tests cover failure cases, not just the happy path?

## Report template

```
## Review result

[MUST FIX]
- `path/file.ts:42`: <issue>. <suggested fix>

[SHOULD FIX]
- ...

[NIT]
- ...

Summary: <1-2 sentence overall assessment>
```

Only report real issues grounded in the code; write "None" for an empty section.
