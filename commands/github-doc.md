# GitHub Doc Fetcher

Fetch and display a markdown document from a private GitHub repository.

## Instructions

The user will provide a GitHub URL (or you may have one from conversation context). Extract the owner, repo, file path, and branch from the URL.

### URL Patterns

```
https://github.com/{owner}/{repo}/blob/{branch}/{path}
```

### Fetch Command

```bash
gh api "repos/{owner}/{repo}/contents/{path}?ref={branch}" --jq '.content' | base64 -d
```

### Steps

1. Parse the GitHub URL to extract owner, repo, branch, and file path
2. Run the `gh api` command above with the extracted values
3. Display the full document content to the user
4. If the file is not found, try without the `?ref=` parameter (defaults to main branch)

### Error Handling

- **404**: Check if the repo name and path are correct. Try listing the directory contents to find the right file.
- **Auth error**: Tell the user to run `gh auth login` to authenticate.

### Arguments

Pass the GitHub URL as the argument: `/github-doc https://github.com/org/repo/blob/branch/path/to/file.md`

If no URL is provided, ask the user for one.
