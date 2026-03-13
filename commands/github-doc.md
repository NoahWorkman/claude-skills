# GitHub Doc Fetcher

Fetch and display content from GitHub repositories using the `gh` CLI.

## Arguments

`$ARGUMENTS` can be any of:
- A GitHub URL (file, directory, PR, issue, release)
- An `owner/repo` shorthand plus a path (e.g., `anthropics/claude-code README.md`)
- Just an `owner/repo` to view the repo overview

## How to handle each URL type

### File
`https://github.com/{owner}/{repo}/blob/{branch}/{path}`
```bash
gh api "repos/{owner}/{repo}/contents/{path}?ref={branch}" --jq '.content' | base64 -d
```

### Directory
`https://github.com/{owner}/{repo}/tree/{branch}/{path}`
```bash
gh api "repos/{owner}/{repo}/contents/{path}?ref={branch}" --jq '.[] | "\(.type)\t\(.name)"'
```
Show the listing, then ask the user which file to fetch.

### Pull request
`https://github.com/{owner}/{repo}/pull/{number}`
```bash
gh pr view {number} --repo {owner}/{repo}
```

### Issue
`https://github.com/{owner}/{repo}/issues/{number}`
```bash
gh issue view {number} --repo {owner}/{repo}
```

### Release
`https://github.com/{owner}/{repo}/releases/tag/{tag}`
```bash
gh release view {tag} --repo {owner}/{repo}
```

### Repo root
`https://github.com/{owner}/{repo}`
```bash
gh repo view {owner}/{repo}
```

## Fallback logic

1. If a file fetch returns 404, try without the `?ref=` parameter (defaults to the repo's default branch).
2. If still 404, list the parent directory to help find the right path.
3. If the repo is not found, check access: `gh api repos/{owner}/{repo} --jq '.private'`

## Display rules

- Markdown files: display content directly.
- Code files: display with the filename as a heading.
- Large files (>500 lines): show the first 100 lines and ask if the user wants the rest.
- Binary files: report the file type and size, don't try to display.

## Error handling

- **404**: Show what was tried. List nearby files if possible.
- **Auth error**: Tell the user to run `gh auth login`.
- **Rate limit**: Tell the user to check `gh auth status`.

If no argument is provided, ask the user for a GitHub URL or repo.
