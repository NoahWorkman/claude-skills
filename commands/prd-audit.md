# PRD Audit

Validate a Product Requirements Document against the PRD skill schema.

## Instructions

1. Read the PRD skill schema from `~/.claude/commands/prd.md`
2. Read the target PRD document (passed as argument, or ask the user for a file path)
3. Map each required schema section to the document and report coverage

### Required Schema Sections

From the PRD skill's Strict Schema:

| # | Section | Required Contents |
|---|---------|-------------------|
| 1 | **Executive Summary** | Problem Statement, Proposed Solution, Success Criteria (3-5 measurable KPIs) |
| 2 | **User Experience & Functionality** | User Personas, User Stories ("As a [user]..."), Acceptance Criteria, Non-Goals |
| 3 | **AI System Requirements** (if applicable) | Tool Requirements, Evaluation Strategy |
| 4 | **Technical Specifications** | Architecture Overview, Integration Points, Security & Privacy |
| 5 | **Risks & Roadmap** | Phased Rollout (MVP > v1.1 > v2.0), Technical Risks |

### Implementation Guidelines Checks

| Guideline | Check |
|-----------|-------|
| **Requirements Quality** | Are criteria concrete and measurable? No "fast", "easy", "intuitive"? |
| **Testing Defined** | For AI systems, is testing/validation specified? |
| **Constraints Stated** | Tech stack, budget, deadline -- stated or marked TBD? |

### Output Format

```
## PRD Audit Results

| Schema Section | Status | Notes |
|----------------|--------|-------|
| Executive Summary | ... | ... |
| User Experience | ... | ... |
| AI System Requirements | ... | ... |
| Technical Specifications | ... | ... |
| Risks & Roadmap | ... | ... |

## Quality Checks
- [ ] All criteria concrete and measurable
- [ ] Testing strategy defined
- [ ] Constraints documented
- [ ] No vague language ("fast", "easy", "intuitive")

## Gaps
[List any missing sections or weak areas]
```

### Arguments

Pass the file path: `/prd-audit /path/to/prd.md`

If no path provided, ask the user which PRD to audit.
