# Conversation Retrospective

Analyze this conversation to improve future Claude Code workflows.

## Instructions

Review the entire conversation and generate a retrospective report.

### 1. Permission Optimization

Identify commands that required approval but could be auto-permitted:

**Look for patterns like:**
- Bash commands you approved multiple times (e.g., `npm run build`, `pnpm dev`)
- File operations in specific directories you always allow
- Git operations on certain branches
- Tool calls to specific MCP servers

**Output format:**
```
## Commands to Consider Auto-Permitting

| Command Pattern | Times Approved | Risk Level | Recommendation |
|-----------------|----------------|------------|----------------|
| `Bash(pnpm build:*)` | 3 | Low | Add to settings |
| `WebFetch(domain:example.com)` | 2 | Low | Add to settings |
```

**How to add:** Remind user that permissions go in `~/.claude/settings.json` under `"permissions"` → `"allow"` array.

### 2. Security Review

Flag any potential security concerns from the session:

- Sensitive data that was handled (API keys, passwords, tokens)
- External domains accessed
- Files modified outside the project
- Commands with elevated privileges
- Any patterns that seemed risky

**Output format:**
```
## Security Notes

✅ **Good practices observed:**
- [Example]

⚠️ **Potential concerns:**
- [Example with recommendation]
```

### 3. Skill Suggestions

Identify repetitive workflows that could become skills:

**Look for:**
- Multi-step sequences you repeated
- Complex commands with many parameters
- Workflows that required multiple tool calls
- Tasks you might want to run again

**Output format:**
```
## Suggested New Skills

### `/skill-name`
**Trigger:** [What pattern suggests this skill]
**What it would do:**
1. [Step 1]
2. [Step 2]

**Draft command file:**
```markdown
# Skill Title
Description of what this skill does.
[Draft instructions]
```
```

### 4. Workflow Improvements

Other observations:
- MCPs that were slow or failed
- Tools that could have been used differently
- Patterns in how you work that could be optimized

---

## Output Summary

End with a quick action list:

```
## Quick Actions

**Permissions to add** (copy to settings.json):
- [ ] `Bash(command:*)`

**Skills to create:**
- [ ] `/skill-name` - [one-line description]

**Security follow-ups:**
- [ ] [Any action needed]
```
