---
name: commit
description: Create a Git commit following recent commit style and manage .gitignore
---

# Git Commit Command

Create a Git commit that follows the repository's recent commit style and actively manages .gitignore for unrelated files.

## Instructions

1. **Analyze recent commits**:
   - Run `git log --oneline -10` to see recent commit messages
   - Identify the commit message style pattern (prefix, format, language)
   - Note any commit conventions (e.g., conventional commits, emoji usage)

2. **Check repository status**:
   - Run `git status` to see all changes
   - Identify which files are related to the current change
   - Flag any unrelated files that should be added to .gitignore

3. **Manage .gitignore**:
   - For unrelated files (e.g., `.DS_Store`, `*.log`, `node_modules/`, `.env`, IDE configs):
     - Add them to .gitignore before committing
     - Common patterns to consider:
       - macOS: `.DS_Store`, `*.swp`
       - IDEs: `.idea/`, `.vscode/`, `*.sublime-*`
       - Logs: `*.log`, `logs/`
       - Dependencies: `node_modules/`, `vendor/`, `venv/`
       - Environment: `.env`, `.env.local`
       - Build artifacts: `dist/`, `build/`, `*.pyc`, `__pycache__/`

4. **Stage appropriate files**:
   - Only stage files related to the current change
   - If .gitignore was updated, stage it as well

5. **Create commit message**:
   - Follow the style of recent commits
   - Be concise but descriptive
   - Include scope if the repository uses it
   - Use the same language as recent commits (English/Japanese)

6. **Commit**:
   - Create the commit with the generated message
   - Show the commit result to confirm success

## Example workflow

```bash
# 1. Check recent commits
git log --oneline -10

# 2. Check status
git status

# 3. Update .gitignore if needed
echo ".DS_Store" >> .gitignore
echo "*.log" >> .gitignore

# 4. Stage files
git add <relevant-files>
git add .gitignore  # if updated

# 5. Commit
git commit -m "feat: add user authentication module"
```

## Notes

- Always prefer to exclude files via .gitignore rather than committing unnecessary files
- When in doubt about a file, check if similar files are already in .gitignore
- Maintain consistency with the existing commit style
- Never commit sensitive information (keys, passwords, tokens)