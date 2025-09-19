---
name: next-approve
description: Approve the /next recommendation, update issue status to In Progress, and create a working branch
---

# Next Approve Command

Start working on the recommended issue from /next by updating its status and creating a dedicated branch.

## Instructions

1. **Verify prerequisites**:
   - Ensure an issue was previously selected with /next
   - Confirm no uncommitted changes exist
   - Check current branch is main/master/develop

2. **Update local repository**:
   - Fetch latest changes from origin
   - Pull/merge updates to ensure working with latest code

3. **Update issue status**:
   - Change issue status from "Todo" to "In Progress" in GitHub Project
   - Assign yourself to the issue if not already assigned

4. **Create feature branch**:
   - Generate branch name from issue number and title
   - Follow naming convention: `feature/#<number>-<brief-description>`
   - For bugs: `fix/#<number>-<brief-description>`
   - Create and checkout the new branch

5. **Setup work environment**:
   - Display issue details for reference
   - Suggest initial steps based on issue type
   - Create initial TODO list if complex task

## Example workflow

```bash
# 1. Verify clean working tree
git status

# 2. Update from origin
git checkout develop  # or main/master
git pull origin develop

# 3. Get issue details (assuming issue #123)
ISSUE_NUMBER=123
ISSUE=$(gh issue view $ISSUE_NUMBER --json title,number,body,labels)

# 4. Update issue status in project
gh issue edit $ISSUE_NUMBER --add-assignee @me

# Update project status (requires project ID)
gh project item-edit --id <item-id> --field-id <status-field> --project-id <project-id> --value "In Progress"

# 5. Create branch
TITLE=$(echo $ISSUE | jq -r .title | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | head -c 30)
BRANCH="feature/#${ISSUE_NUMBER}-${TITLE}"
git checkout -b $BRANCH

# 6. Display starting context
echo "✅ Branch created: $BRANCH"
echo "📋 Issue: #$ISSUE_NUMBER"
echo "Now working on: $(echo $ISSUE | jq -r .title)"
```

## Suggested lightweight prompts

Based on issue type, suggest one of these brief starting points:

**For bugs**:
```
🐛 Bug fix checklist:
1. Reproduce the issue
2. Write failing test
3. Implement fix
4. Verify all tests pass
```

**For features**:
```
✨ Feature checklist:
1. Review requirements
2. Design implementation
3. Write tests
4. Implement feature
```

**For refactoring**:
```
🔧 Refactor checklist:
1. Identify affected areas
2. Ensure test coverage
3. Make changes incrementally
4. Verify no regressions
```

## Branch naming patterns

- Features: `feature/#123-add-auth`
- Bugs: `fix/#123-login-error`
- Hotfixes: `hotfix/#123-critical-bug`
- Chores: `chore/#123-update-deps`

## Quick start message

After branch creation, display:
```
Ready to work on #[number]!
Branch: [branch-name]
Type: [bug/feature/chore]

💡 Tip: Start with understanding the issue context and affected code areas.
```

## Notes

- Automatically detects issue type from labels
- Keeps branch names concise (max 50 chars)
- Preserves issue number for easy reference
- Minimal prompts to avoid overwhelming
- Can be customized per project conventions