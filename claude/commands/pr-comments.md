---
name: pr-comments
description: Fetch and display comments from a GitHub pull request
---

# Pull Request Comments Command

Retrieve and display all comments for a GitHub pull request, including both issue-level and code review comments.

## Instructions

1. **PR Information Retrieval**:
   - Validate current repository is a GitHub repository
   - Fetch PR number and repository details
   - Handle cases of current branch vs specified PR number

2. **Comment Fetching**:
   - Fetch issue-level comments
   - Fetch code review comments
   - Parse and organize comments by thread
   - Handle nested replies

3. **Output Formatting**:
   - Display comments with context
   - Show file and line references
   - Preserve comment threading
   - Use readable, compact format

## Example Workflow

```bash
# Fetch comments for current PR
gh pr comments

# Fetch comments for specific PR number
gh pr comments 123
```

## Comment Retrieval Script

```bash
#!/bin/bash

# Fetch PR details
PR_INFO=$(gh pr view --json number,headRepository)
PR_NUMBER=$(echo "$PR_INFO" | jq -r .number)
REPO_OWNER=$(echo "$PR_INFO" | jq -r .headRepository.owner.login)
REPO_NAME=$(echo "$PR_INFO" | jq -r .headRepository.name)

# Fetch issue comments
ISSUE_COMMENTS=$(gh api "/repos/$REPO_OWNER/$REPO_NAME/issues/$PR_NUMBER/comments")

# Fetch review comments
REVIEW_COMMENTS=$(gh api "/repos/$REPO_OWNER/$REPO_NAME/pulls/$PR_NUMBER/comments")

# Process and display comments
process_comments() {
    # Implement comment parsing and formatting logic
}

process_comments
```

## Comment Formatting Guidelines

- Use concise, readable output
- Show comment author, file, and line context
- Preserve comment threads
- Highlight code references
- Handle various comment types (general, review, inline)

## Notes

- Requires GitHub CLI (`gh`) installed
- Must be run in a GitHub repository
- Supports current PR or specific PR number
- Respects repository permissions