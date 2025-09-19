---
name: pr
description: Create a pull request with automatic branch push and issue linking
---

# Pull Request Command

Create a pull request by pushing the current feature branch to remote and automatically linking related issues.

## Instructions

1. **Pre-flight checks**:
   - Ensure all changes are committed
   - Run tests if configured (`npm test`, `pytest`, etc.)
   - Run linters if configured (`npm run lint`, `ruff`, etc.)
   - Check for uncommitted changes with `git status`

2. **Branch validation**:
   - Verify current branch is not main/master/develop
   - Get current branch name with `git branch --show-current`
   - Check if branch follows naming convention (e.g., feature/*, fix/*, hotfix/*)

3. **Sync with upstream**:
   - Fetch latest changes from origin
   - Check if local branch is behind remote dev (default) or main/master
   - Optionally rebase or merge latest changes from dev branch

4. **Extract issue information**:
   - Look for issue number in branch name (e.g., feature/123-add-auth)
   - Check recent commit messages for issue references
   - Search for TODO comments or issue references in changed files

5. **Push to remote**:
   - Push current branch to origin with same name
   - Use `git push -u origin <branch-name>` for first push
   - Use `git push` for subsequent pushes

6. **Create pull request**:
   - Generate PR title from branch name and recent commits
   - Create PR body with:
     - Summary of changes
     - `Closes #<issue-number>` or `Fixes #<issue-number>`
     - Testing checklist
     - Screenshots if UI changes
   - Use `gh pr create` command with appropriate flags
   - Target branch should be `dev` by default (use `--base dev`)
   - Set reviewers if specified in CODEOWNERS or team conventions

7. **Post-creation tasks**:
   - Add labels based on change type (feature, bug, docs, etc.)
   - Link to related PRs if any
   - Update issue status if using project boards
   - Share PR link with user

## Example workflow

```bash
# 1. Pre-flight checks
git status
npm test
npm run lint

# 2. Get current branch
BRANCH=$(git branch --show-current)

# 3. Sync with upstream
git fetch origin
git rebase origin/dev  # default target branch

# 4. Push to remote
git push -u origin $BRANCH

# 5. Create PR with issue linking (targeting dev branch)
gh pr create \
  --base dev \
  --title "feat: add user authentication" \
  --body "## Summary
  Add JWT-based authentication system

  Closes #123

  ## Changes
  - Add login endpoint
  - Add JWT token generation
  - Add auth middleware

  ## Testing
  - [ ] Unit tests pass
  - [ ] Integration tests pass
  - [ ] Manual testing completed"
```

## Recommended additional steps

1. **Code quality**:
   - Run code coverage check
   - Ensure no console.logs or debug statements
   - Check for proper error handling

2. **Documentation**:
   - Update README if needed
   - Add/update API documentation
   - Update CHANGELOG.md

3. **Dependencies**:
   - Check for security vulnerabilities (`npm audit`)
   - Ensure lock files are committed

4. **Commit hygiene**:
   - Squash WIP commits if needed
   - Ensure commit messages follow convention

## Notes

- Always check project-specific PR templates in `.github/pull_request_template.md`
- Follow team conventions for PR titles and labels
- Ensure CI/CD checks pass before requesting review
- Never push directly to protected branches