Audit Tailwind CSS text/background color pairings for readability on dark themes.

1. Identify the target files -- if the user specifies components, use those. Otherwise scan all `.tsx` files in the current project for Tailwind color classes.

2. For each file, extract all text/background color pairings by looking for:
   - `text-zinc-*`, `text-gray-*`, `text-slate-*`, `text-neutral-*`, `text-white` classes
   - `bg-zinc-*`, `bg-gray-*`, `bg-slate-*`, `bg-neutral-*`, `bg-black` classes
   - Inline `style` color/backgroundColor values
   - Classes on parent elements that set background for child text

3. Flag problematic pairings where text and background are too close in lightness:
   - `text-zinc-500` or darker on `bg-zinc-800` or darker = FAIL
   - `text-zinc-400` on `bg-zinc-700` or darker = WARNING
   - Any text class `zinc-400` or higher number on backgrounds `zinc-800`+ = FAIL
   - Semi-transparent backgrounds (`bg-zinc-800/50`) make contrast worse -- flag these

4. For each issue found, output:
   - File path and line number
   - Current pairing (e.g., `text-zinc-500 on bg-zinc-900`)
   - Suggested fix (e.g., `text-zinc-300`)

5. Present results as a table:
   ```
   | File:Line | Current | Issue | Suggested Fix |
   ```

6. After reporting, ask the user if they want the fixes applied.

Guidelines:
- Minimum readable text on dark backgrounds: `text-zinc-300` for body text, `text-zinc-200` for labels/chips
- Buttons and interactive elements need explicit text color -- never rely on inheritance on dark themes
- `text-white` is always safe on dark backgrounds
- Placeholder text can be `text-zinc-400` but no darker
