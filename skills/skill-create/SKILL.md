---
name: skill-create
description: "Use when creating a new skill or auditing existing skills for quality. Triggers on: /skill-create <name>, /skill-create audit <name>, /skill-create audit-all. Enforces best practices (9 categories, folder structure, progressive disclosure, gotchas, description-as-trigger) at creation time."
user-invocable: true
category: code-scaffolding
---

# /skill-create -- Skill Creator & Auditor

Create new skills that follow best practices, or audit existing skills against the quality framework.

## Arguments

`$ARGUMENTS` determines the mode:

- `<name>` -- Create a new skill with that name
- `audit <name>` -- Audit a single existing skill
- `audit-all` -- Audit all skills and commands, sorted by grade

## Mode 1: Create

### Step 1: Classify

Ask the user which category this skill belongs to (or infer from the name/description). Show the category definition from `references/framework.md`.

Valid categories (from `references/framework.md`):
1. Library/API Reference
2. Product Verification
3. Data Fetching
4. Business Process
5. Code Scaffolding
6. Code Quality
7. CI/CD & Deployment
8. Runbooks
9. Infrastructure Ops

If the user provides a description, infer the best-fit category and confirm: "This sounds like a **{category}** skill. Correct?"

### Step 2: Scaffold

1. Create folder: `~/.claude/skills/<name>/`
2. Read `assets/skill-template.md` and copy to `~/.claude/skills/<name>/SKILL.md`
3. Fill in frontmatter: name, description placeholder from user input, `user-invocable: true`, category
4. Read `assets/folder-templates.json` to determine which subdirectories this category needs
5. Create those subdirectories with `.gitkeep` files
6. The SKILL.md template already includes `## Gotchas` and progressive disclosure sections

Ask the user:
- What does this skill do? (becomes the description -- make it trigger-oriented per `references/authoring-principles.md`)
- What are the arguments? (becomes `$ARGUMENTS` section)

### Step 3: Validate Scaffold

Run the structural audit against the new folder:

```bash
bash ~/.claude/skills/skill-create/scripts/structural-audit.sh ~/.claude/skills/<name>
```

Parse the JSON output. The scaffold should score 8-9/11 out of the gate.

Report to the user:
- Current structural grade
- Which checks are still failing (typically S10 trigger language and S11 data/ until user fills in content)
- What they need to do next to complete the skill

## Mode 2: Audit

### Single Skill (`audit <name>`)

**Layer 1: Structural Score**

Determine the skill path. Check both locations:
- `~/.claude/skills/<name>/SKILL.md` (folder skill)
- `~/.claude/skills/<name>/SKILL.md` not found -> `~/.claude/commands/<name>.md` (flat command)

Run the structural audit:

```bash
bash ~/.claude/skills/skill-create/scripts/structural-audit.sh <skill-path>
```

Parse JSON output for structural grade.

**Layer 2: Content Review**

Read the skill's SKILL.md (or .md file for commands). Assess against 3 principles from `references/authoring-principles.md`:

1. **Don't state the obvious** -- Flag specific lines/sections that contain information Claude already knows from training data or codebase context. These are wasted tokens.
2. **Avoid railroading** -- Flag instructions so prescriptive they prevent Claude from adapting. Look for rigid step-by-step sequences where judgment calls would be better.
3. **Category fit** -- Does this skill cleanly fit one of the 9 categories? Flag if it straddles multiple.

Present content findings as a bulleted list under each principle. Do NOT assign a numeric score to content review.

**Log the audit:**

Append a JSON line to `~/.claude/skills/skill-create/data/audit-history.jsonl`:

```json
{"skill": "<name>", "date": "YYYY-MM-DD", "structural_score": N, "structural_grade": "X", "content_findings": ["finding1", "finding2"], "category": "<category>"}
```

**Present results:**

```
## <name> -- Structural Grade: B (7/11)

### Structural Checks
S1 Folder structure:      PASS
S2 Frontmatter exists:    PASS
...

### Content Review
**Don't state the obvious:**
- Lines 15-20 explain what JSON is -- Claude knows this

**Avoid railroading:**
- (none found)

**Category fit:**
- Best fit: Business Process
- No straddling detected

### Upgrade Recommendations
1. Add a `data/` directory for storing run history
2. Add trigger language to description (e.g., "Use when...")
```

### All Skills (`audit-all`)

1. Scan `~/.claude/skills/*/SKILL.md` for folder skills
2. Scan `~/.claude/commands/*.md` for flat commands (exclude `_deprecated/`)
3. Run `structural-audit.sh` on each
4. Sort results by structural grade (worst first: D, C, B, A)
5. Present a summary table:

```
| Skill/Command     | Type    | Grade | Score | Top Finding                    |
|-------------------|---------|-------|-------|--------------------------------|
| intro-reply       | command | D     | 2/11  | No frontmatter, no folder      |
| deploy-check      | skill   | C     | 5/11  | Flat structure, no gotchas      |
| my-pipeline       | skill   | A     | 10/11 | Missing trigger language         |
```

6. Below the table, list migration priorities: commands scoring D that appear high-traffic.

Do NOT run Layer 2 content review on all skills during audit-all (too slow). Only Layer 1 structural scores. Users can run `audit <name>` for deep review on specific skills.

7. Log all results to `data/audit-history.jsonl`.

## Gotchas

- **Flat commands have no folder.** When auditing a flat `.md` file in `~/.claude/commands/`, most structural checks (S1, S8, S9, S11) will fail by definition. This is expected -- that's why they score D. Don't treat it as an error.
- **Category inference is imperfect.** If the name doesn't clearly map to a category, ask rather than guess wrong. A miscategorized skill gets wrong subdirectories.
- **Description is the trigger.** The frontmatter `description` field is what Claude uses to decide whether to invoke the skill. It must contain trigger language ("Use when...", "Triggers on..."). A technically accurate but trigger-less description means the skill never gets auto-invoked.
- **audit-all can be slow.** With many skills/commands, the structural script runs fast but presenting results takes care. Keep the table compact.
- **Don't confuse structural grade with quality.** A skill can score A structurally but have terrible content. The structural grade only measures whether the packaging follows best practices. Content review is separate and intentionally not scored.

## References

- `references/framework.md` -- 9 category definitions with examples
- `references/authoring-principles.md` -- Content quality principles
- `assets/skill-template.md` -- SKILL.md scaffold used in create mode
- `assets/folder-templates.json` -- Category to subdirectory mapping
- `scripts/structural-audit.sh` -- Deterministic structural scoring (11 checks)
- `data/audit-history.jsonl` -- Historical audit results
