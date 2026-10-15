---
description: Create a commit following Conventional Commits
argument-hint: "[extra notes for the commit message]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*)
---

## Context

- Status: !`git status --short`
- Staged changes: !`git diff --staged`
- Unstaged changes: !`git diff`
- Recent commits: !`git log --oneline -5`

## Task

1. If nothing is staged, stage the files that belong to one logical change. Never stage files containing secrets (`.env`, keys, tokens).
2. Write the commit message as `type(scope): short description`:
   - `type`: feat, fix, docs, refactor, test, chore, perf, style, ci
   - Imperative mood, at most 72 characters, no trailing period
   - Add a body when the **why** behind the change needs explaining
3. If the changes cover several unrelated things, suggest splitting them into separate commits.
4. Run `git commit` and report the hash and message.

Extra notes from the user: $ARGUMENTS
