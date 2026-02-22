# Conversation Retrospective

Analyze this conversation to improve future Claude Code workflows.

## Instructions

### FIRST: Read Current State

**Before analyzing anything else:**
1. Read `~/.claude/settings.json` to understand current permissions
2. Read the project's auto memory (if it exists) to understand what's already saved
3. Note the working directory this session was launched from

Store the `permissions.allow` array in memory so you can filter out already-permitted commands.

Common broad patterns to watch for:
- `Bash(git:*)` covers all git commands
- `Bash(pnpm:*)` covers all pnpm commands
- `Bash(npm:*)` covers all npm commands

---

### 1. Permission Optimization

Identify commands that required approval but could be auto-permitted.

**IMPORTANT:** Only recommend permissions NOT already covered by existing patterns in settings.json. Check if a broader pattern already exists before recommending a specific one.

**Look for patterns like:**
- Bash commands you approved multiple times (e.g., `npm run build`, `pnpm dev`)
- File operations in specific directories you always allow
- Git operations on certain branches
- Tool calls to specific MCP servers
- WebFetch domains accessed that could be allowlisted

**Output format:**
```
## Permission Optimization

| Command Pattern | Times Approved | Risk Level | Recommendation |
|-----------------|----------------|------------|----------------|
| `Bash(pnpm build:*)` | 3 | Low | Add to settings |
| `WebFetch(domain:example.com)` | 2 | Low | Add to settings |
```

If all commands were already covered by existing permissions, say so. Permissions go in `~/.claude/settings.json` under `"permissions"` > `"allow"` array.

---

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

Good practices observed:
- [Example]

Potential concerns:
- [Example with recommendation]
```

---

### 3. Skill & Agent Audit

Evaluate whether any session workflows should become reusable components. There are THREE distinct types:

**Slash commands** (user-invoked, `~/.claude/commands/`)
- Repeatable workflows triggered by `/command-name`
- Good for: multi-step processes, frequently repeated tasks, workflows with arguments
- File: `~/.claude/commands/command-name.md`
- Use `$ARGUMENTS` for input

**Auto-invoked skills** (`.claude/skills/` in project repos)
- Domain knowledge Claude applies automatically when relevant
- Good for: coding conventions, API patterns, project-specific rules
- File: `.claude/skills/skill-name/SKILL.md` with YAML frontmatter
- Set `disable-model-invocation: true` for side-effect workflows

**Custom subagents** (`.claude/agents/` in project repos)
- Specialized assistants for isolated tasks with their own context
- Good for: code review, security audit, research tasks, analysis
- File: `.claude/agents/agent-name.md` with YAML frontmatter (name, description, tools, model)
- Run in separate context windows to avoid polluting main conversation

**Look for in this session:**
- Multi-step sequences that were repeated > slash command
- Domain knowledge Claude had to rediscover > auto-invoked skill
- Research or analysis that consumed lots of context > subagent
- Workflows that could benefit from scoped tool access > subagent

**Output format:**
```
## Skill & Agent Suggestions

### Slash Commands (to ~/.claude/commands/)
[List any suggested commands with draft content]

### Auto-Invoked Skills (to .claude/skills/ in relevant repo)
[List any suggested skills]

### Custom Subagents (to .claude/agents/ in relevant repo)
[List any suggested agents with tool restrictions]
```

If nothing is warranted, say "No new skills or agents needed from this session."

---

### 4. Memory Assessment

**Be conservative.** Only recommend saving things that are:
- Confirmed across multiple interactions (not speculative)
- Stable patterns unlikely to change soon
- Not already documented in CLAUDE.md files or existing memory
- Genuinely useful for future sessions (not session-specific state)

**Check for:**
- New project patterns or conventions discovered
- Key architectural decisions that should persist
- User workflow preferences expressed during the session
- Solutions to problems that could recur
- Corrections to existing memory that's now outdated

**Do NOT recommend saving:**
- In-progress work or temporary task state
- Information already in a CLAUDE.md file
- Things learned from reading one file that might be incomplete
- Session-specific context (current branch, current bug, etc.)

**Memory locations:**
- `~/.claude/projects/<project>/memory/MEMORY.md` -- concise index (first 200 lines loaded per session)
- `~/.claude/projects/<project>/memory/<topic>.md` -- detailed topic files (read on demand)
- If the user explicitly asked to remember something, always save it

**Output format:**
```
## Memory Assessment

### Save to auto memory:
- [Item] -- reason it's worth persisting

### Update existing memory:
- [Item in MEMORY.md that's now outdated] -- what changed

### No action needed:
[If nothing warrants saving]
```

---

### 5. Session Hygiene

Review the session against Claude Code best practices. Check for:

**Working directory:**
- Was this session launched from `~` (home directory)?
- If yes: would the session have benefited from launching inside a project directory?
- Launching from a project directory gives: project-specific CLAUDE.md, project-scoped auto memory, cleaner context
- Launching from `~` is fine for: cross-project work, general tasks, skill development

**Context management:**
- Did context get cluttered with failed approaches? Should have used `/clear`
- Were there long exploration tangents? Should have used subagents
- Was `/compact` needed but not used?

**Workflow patterns:**
- Did the session follow explore > plan > implement > verify?
- Were verification criteria provided for changes?
- Were MCP tools or CLI tools used efficiently?
- Could any part have been parallelized with multiple sessions?

**CLAUDE.md health:**
- Is the CLAUDE.md getting too long? (Claude ignores bloated files)
- Are there instructions Claude already follows without being told?
- Are there rules Claude keeps breaking despite the instruction?

**Output format:**
```
## Session Hygiene

**Working directory:** [Assessment + recommendation if applicable]

**Best practices followed:**
- [Example]

**Improvements for next time:**
- [Specific suggestion]
```

---

### 6. One Thing Learned

Share one practical insight from the session. Pick from:

- **Claude Code feature** -- a trick, shortcut, or workflow pattern
- **Agent pattern** -- how to use subagents, headless mode, or fan-out
- **Coding concept** -- a pattern relevant to what was done in the session
- **Tool/ecosystem insight** -- something about a tool or service touched in the session

Keep it to 2-4 sentences. Prioritize being genuinely useful over forced relevance.

---

## Output Summary

End with a consolidated action list:

```
## Quick Actions

**Permissions to add** (copy to ~/.claude/settings.json > permissions > allow):
- [ ] `Bash(command:*)`

**Skills/agents to create:**
- [ ] `/skill-name` in `~/.claude/commands/` -- [description]
- [ ] `agent-name` in `.claude/agents/` -- [description]

**Memory updates:**
- [ ] [What to save and where]

**Session hygiene:**
- [ ] [Working directory recommendation]
- [ ] [Other improvement]

**Security follow-ups:**
- [ ] [Any action needed]
```
