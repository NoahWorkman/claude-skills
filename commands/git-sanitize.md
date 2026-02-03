# Git Sanitize - Scan for Sensitive Info Before Pushing

Scan the current repo for sensitive information before it goes public.

## What to scan

Run these checks in order:

### 1. Staged changes
Check `git diff --cached` for sensitive patterns.

### 2. Full history
Check `git log --all -p` for sensitive patterns.

### 3. Sensitive patterns to match
- Absolute paths with usernames (e.g., /Users/*, /home/*)
- UUIDs that look like tenant/project/user IDs (8-4-4-4-12 format, excluding common false positives in package-lock or node_modules)
- API keys, tokens, secrets (look for key=, token=, secret=, password=, Bearer)
- Email addresses
- Internal/staging URLs (localhost, 127.0.0.1, *.internal, *.local)
- .env file contents

### 4. Exclude from scan
- node_modules/
- package-lock.json / pnpm-lock.yaml
- .git/ internals
- Binary files
- The git author name/email (that's public GitHub identity, not a leak)
- Mentions of patterns in audit/security rule files (e.g., "scan for localhost" is not a leak of localhost)

## Output format

```
## Git Sanitize Report

**Staged changes:** CLEAN / [N findings]
**Git history:** CLEAN / [N findings]

### Findings
| Location | Type | Content | Line |
|----------|------|---------|------|
| [file or commit] | [path/uuid/key/email] | [redacted preview] | [line #] |

### Recommendation
[SAFE TO PUSH / SQUASH NEEDED / FIX BEFORE PUSHING]
```

## Rules
- If history has leaks but staged changes are clean, recommend squashing history
- If staged changes have leaks, list them and stop — do not push
- Keep the report concise, group similar findings
