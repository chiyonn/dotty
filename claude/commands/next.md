---
name: next
description: Select the most important TODO issue from GitHub Projects and explain why it should be worked on next
---

# Next Task Command

Analyze GitHub Project TODO issues and recommend the most important task to work on next with reasoning.

## Instructions

1. **Fetch repository information**:
   - Get current repository owner and name
   - Verify GitHub repository connection

2. **Find associated GitHub Projects**:
   - List all projects associated with the repository
   - Use `gh project list --owner <owner>` or repository-specific projects

3. **Fetch TODO issues**:
   - Query project items with TODO status
   - Get issue details including:
     - Title and description
     - Labels (priority, bug, feature, etc.)
     - Assignees
     - Creation date
     - Comments count
     - Linked pull requests
     - Dependencies/blockers

4. **Prioritization criteria**:
   - **Critical factors**:
     - Security issues or critical bugs
     - Production blockers
     - High priority labels

   - **Important factors**:
     - Dependencies for other issues
     - User-reported bugs
     - Features with deadlines
     - Issues blocking team members

   - **Consideration factors**:
     - Age of issue (older may indicate neglect)
     - Community engagement (comments, reactions)
     - Effort estimation (if available)
     - Technical debt impact

5. **Analysis and selection**:
   - Score each issue based on criteria
   - Consider dependencies and blockers
   - Select the highest priority task
   - Generate clear reasoning for selection

6. **Output format**:
   ```
   🎯 Recommended Next Task: #[issue_number]

   **Title**: [Issue title]

   **Why this task**:
   - [Primary reason]
   - [Secondary reason]
   - [Additional context]

   **Summary**:
   [Brief description of what needs to be done]

   **Labels**: [label1] [label2]
   **Estimated effort**: [if available]
   **Blocked by**: [if any]
   ```

## Example workflow

```bash
# 1. Get repository info
REPO=$(gh repo view --json owner,name)
OWNER=$(echo $REPO | jq -r .owner.login)
NAME=$(echo $REPO | jq -r .name)

# 2. Find projects
PROJECTS=$(gh project list --owner $OWNER --format json)

# 3. For each project, get TODO items
for PROJECT_ID in $(echo $PROJECTS | jq -r '.[].number'); do
    # Get project items with TODO status
    gh project item-list $PROJECT_ID --owner $OWNER --format json | \
    jq '.items[] | select(.status == "Todo" or .status == "TODO")'
done

# 4. Get issue details for each TODO
gh issue list --state open --label "todo" --json number,title,labels,createdAt,body

# 5. Analyze and prioritize
# Implementation of scoring logic
```

## Prioritization algorithm

```python
def calculate_priority_score(issue):
    score = 0

    # Critical bugs get highest priority
    if has_label(issue, ['critical', 'security', 'blocker']):
        score += 1000

    # High priority items
    if has_label(issue, ['high-priority', 'urgent']):
        score += 500

    # Bug vs feature
    if has_label(issue, 'bug'):
        score += 200

    # Age factor (older issues get slight boost)
    days_old = (now - issue.created_at).days
    score += min(days_old * 2, 100)

    # Community interest
    score += issue.comments_count * 10
    score += issue.reactions_count * 5

    # Dependencies
    if issue.blocks_other_issues:
        score += 300

    return score
```

## Notes

- Requires GitHub CLI with project permissions
- Works best with well-labeled issues
- Consider team capacity and expertise
- May need to configure project field mappings
- Respects project-specific workflows