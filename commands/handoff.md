# Session Handoff

Generate a resume prompt so you can pick up this conversation in a new terminal session.

## Instructions

Review the entire conversation and create a handoff document.

### 1. Session Summary

Write 2-3 sentences capturing what this session was about.

### 2. Key Decisions Made

Bullet list of decisions, conclusions, or direction changes during this session.

### 3. Files Created or Modified

List all files that were created, edited, or are central to resuming:

```
**Created:**
- `path/to/file.md` -- [what it is]

**Modified:**
- `path/to/file.md` -- [what changed]

**Key reference files:**
- `path/to/file.md` -- [why it matters]
```

### 4. Current Status

Where things stand right now. What's done, what's pending.

### 5. Next Steps

Immediate action items or tasks that were identified but not completed.

### 6. Resume Prompt

Generate a copy-pasteable prompt block:

```
---
RESUME PROMPT -- Copy everything between the dashes into a new Claude Code session
---

[Session topic in one sentence]

**What we did:** [2-3 sentences]

**Key files:**
- `path/to/file` -- [description]

**Current status:** [1-2 sentences]

**Next steps:** [Bullet list of what to do next]

**Context:** [Any important background, constraints, or decisions that were made]

---
```

## Output

Display the resume prompt directly in the terminal so the user can copy it immediately.
