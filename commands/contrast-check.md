# Contrast Check

Audit text/background color pairings in Tailwind CSS for readability, especially on dark themes.

## Scope

Scan the files the user specifies. If none specified, scan all component files in the project (`.tsx`, `.jsx`, `.vue`, `.html`, `.svelte`).

## What to look for

Extract all text/background color pairings:

- Tailwind classes: `text-{color}-{shade}` paired with `bg-{color}-{shade}`
- All color scales: zinc, gray, slate, neutral, stone, red, blue, green, etc.
- Inline styles with `color` / `backgroundColor`
- Parent backgrounds inherited by child text
- Dynamic/conditional classes (e.g., `${darkMode ? 'text-zinc-500' : 'text-zinc-200'}`) -- evaluate both branches
- Semi-transparent backgrounds (`bg-zinc-800/50`) -- note these reduce contrast further

## Contrast rules

**FAIL** -- unreadable, must fix:
- Text shade >= 500 on background shade >= 800 (e.g., `text-zinc-500 on bg-zinc-900`)
- Any pairing where the shade difference is < 300 and both shades are >= 600

**WARNING** -- borderline, review needed:
- Text shade 400 on background shade >= 700
- Semi-transparent backgrounds where underlying contrast is unknown

**PASS** -- no action:
- `text-white` or `text-{color}-100/200/300` on dark backgrounds
- Shade difference >= 400

## Minimum readable shades (dark backgrounds)

- Body text: `text-{color}-300` or lighter
- Labels and chips: `text-{color}-200` or lighter
- Placeholder text: `text-{color}-400` (absolute minimum)
- Interactive elements (buttons, links): always set explicit text color, never rely on inheritance

## Output

Present findings as a table:

| File:Line | Current Pairing | Verdict | Suggested Fix |

Group by file. Show FAIL items first, then WARNINGs.

After the report, ask the user if they want the fixes applied.
