---
name: {{SKILL_NAME}}
description: "{{DESCRIPTION -- make this trigger-oriented: 'Use when...', 'Triggers on...'}}"
user-invocable: true
category: {{CATEGORY}}
---

# /{{SKILL_NAME}}

{{One-line summary of what this skill does.}}

## Arguments

`$ARGUMENTS` is {{describe expected arguments, or "not used" if none}}.

## Workflow

### Step 1: {{First major step}}

{{What this step does and why. Reference subdirectory files when details are needed:}}
{{e.g., "See `references/api-docs.md` for the full endpoint specification."}}

### Step 2: {{Second major step}}

{{Continue the workflow. Each step should be a meaningful unit of work, not a single command.}}

## Gotchas

<!-- Add failure points as you discover them. This section is the most valuable over time. -->

## References

{{List all files in subdirectories that this skill uses:}}
{{- `references/` -- detailed documentation}}
{{- `assets/` -- templates and static files}}
{{- `scripts/` -- executable logic}}
{{- `data/` -- runtime state and logs}}
