# Skill Authoring Principles

Content quality principles for writing effective Claude Code skills. These complement the structural checks in `scripts/structural-audit.sh`.

## 1. Don't State the Obvious

Every line in a skill costs tokens. If Claude already knows it from training data or can derive it from the codebase, don't repeat it.

**Bad:** "JSON is a data format. Use `JSON.parse()` to parse JSON strings into objects."
**Good:** "Parse the config file. If `retryCount` is missing, default to 3."

**Bad:** "Git is a version control system. Use `git commit` to save changes."
**Good:** "Commit after each passing test. Message format: `<type>: <what changed>`"

**Test:** Would removing this line change Claude's behavior? If not, delete it.

## 2. Avoid Railroading

Skills should encode *what* and *why*, not rigid *how*. Over-prescriptive steps prevent Claude from adapting to the actual situation.

**Bad:**
```
Step 1: Open the file
Step 2: Find line 42
Step 3: Change "foo" to "bar"
Step 4: Save the file
```

**Good:**
```
Replace all uses of the deprecated `foo` API with `bar`. The migration guide is at references/foo-to-bar.md.
```

**When rigid steps ARE appropriate:** External API sequences where order matters, or safety-critical operations where skipping a step causes data loss.

## 3. Description is for the Model

The frontmatter `description` field determines when Claude auto-invokes the skill. It's a trigger, not documentation.

**Bad:** `description: "A tool for managing deployments"`
**Good:** `description: "Use when deploying to production, checking deploy status, or rolling back a failed deploy. Triggers on: /deploy, 'push to prod', 'is the deploy healthy?'"`

**Include:**
- Trigger phrases users actually say
- Situations where this skill should activate
- Adjacent skills it should NOT be confused with

## 4. Progressive Disclosure

Don't front-load everything into SKILL.md. Use subdirectories to store details that are only needed at specific steps.

**Pattern:**
- `SKILL.md` -- orchestrator with high-level steps
- `references/` -- detailed docs loaded only when a step needs them
- `scripts/` -- executable logic that SKILL.md calls
- `assets/` -- templates, examples, static files
- `data/` -- runtime state, logs, history

Claude reads SKILL.md first. It only reads subdirectory files when the current step references them. This keeps the initial context small.

## 5. Build a Gotchas Section

Every skill should have a `## Gotchas` section documenting failure modes discovered through use. This is the most valuable section over time.

**What to include:**
- Failure modes that aren't obvious from the code
- Workarounds for known issues
- Common mistakes users make when invoking the skill
- Edge cases where the skill behaves unexpectedly

**When to add:** After every incident where the skill produced a wrong or unexpected result. The gotcha should prevent the same failure from recurring.

Start with an empty section and a comment: `<!-- Add failure points as you discover them -->`. It will fill up naturally.
