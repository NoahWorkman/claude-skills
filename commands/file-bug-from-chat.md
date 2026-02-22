# File Bug from Chat

Extract bugs, tech debt, and engineering issues discovered during the current conversation and file them as structured reports.

Unlike a traditional bug report (where someone hands you a transcript of a single issue), this skill works when the CONVERSATION ITSELF contains the issues. It scans the full chat history, identifies distinct problems, and lets the user pick which ones to file.

## When to Use

- After a code audit that surfaced problems
- When a debugging session revealed multiple issues
- When a conversation uncovered tech debt, architectural concerns, or dependency risks
- Anytime the user says "this conversation has the bug" or "file issues from this session"

## Input

- **No input required.** The conversation history IS the input.
- If the user provides arguments, treat them as hints about which issues to focus on.

## Workflow

### Phase 1: Scan the Conversation

Read the full conversation history. Identify every distinct issue, categorized as:

- **Bug**: Something is broken or producing wrong results
- **Tech Debt**: Code that works but is fragile, duplicated, outdated, or hard to maintain
- **Dependency Risk**: A library or service that needs replacement, upgrade, or migration
- **Architecture Issue**: Structural problems (inconsistent patterns, missing abstractions, scaling concerns)
- **Missing Feature**: Functionality gaps discovered during the work

For each issue found, extract:
1. A concise title
2. What product area it affects
3. A plain-language description with full context from the conversation
4. Severity: Critical / High / Medium / Low
5. Any relevant file paths, code snippets, or error messages from the conversation

### Phase 2: Present Candidates

Show the user a numbered list of all issues found:

```
Found N issues in this conversation:

1. [Bug] Title - severity - product area
2. [Tech Debt] Title - severity - product area
3. [Architecture] Title - severity - product area
...
```

Ask: "Which ones should I file? (all, or list numbers like 1,3,5)"

Do NOT file anything without the user confirming which issues to report.

### Phase 3: Investigate (Quick)

For each issue the user selects, do a fast codebase search:
- Look for related files, recent git commits, and similar patterns
- Check for existing issues or TODO comments about the same problem
- This should be fast (30 seconds max per issue). Don't block filing on investigation.

### Phase 4: Write Reports

For each selected issue, generate a report using the template below and save it to the project's issues or docs directory. Ask the user where to save if unclear.

## Report Template

```markdown
# {Type}: {Concise Title}

**Date:** {YYYY-MM-DD}
**Priority:** {Critical / High / Medium / Low}
**Type:** {Bug / Tech Debt / Dependency Risk / Architecture Issue / Missing Feature}
**Product Area:** {Component or system name}

---

## Summary

{2-4 sentences describing the issue clearly. What's wrong, why it matters, and what the impact is.}

## Details

{Full context from the conversation. Include what was being investigated, what was found, specific files/code involved, and why this is a problem. This should give an engineer enough context to understand and act on it without re-doing the investigation.}

## Affected Files

- `path/to/file.ts` - {what's relevant about this file}

## Recommended Action

{What should be done about this. Be specific: "Migrate X to Y", "Replace A with B", "Consolidate these two patterns into one".}

## Investigation Notes

{Any codebase search findings, related commits, or past issues. Remove section if none.}

## Conversation Context

> {Include the most relevant 3-10 lines from the conversation that surfaced this issue.}
```

## Priority Guidelines

- **Critical**: Production is broken, data loss risk, or security vulnerability
- **High**: Core feature degraded, blocks important workflow, or dependency at EOL
- **Medium**: Works but fragile, inconsistent patterns, or technical debt with workaround
- **Low**: Cosmetic, minor inconsistency, or "nice to have" improvement

## Notes

- Tech debt and architecture issues are valid things to file. Not everything is a "bug."
- Group related issues when it makes sense (e.g., "dual ffmpeg patterns" is one issue, not two)
- If the conversation was long, focus on issues that are actionable, not every observation
- Don't file things the user explicitly said they're handling themselves
