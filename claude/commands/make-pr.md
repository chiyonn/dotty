---
name: make-pr
description: Create PR with automatic issue linking using $CURRENT_ISSUE
---

# Make PR

$CURRENT_ISSUEを自動リンクしてPR作成

## 実行手順
1. **$CURRENT_ISSUEが作業内容と一致するか確認**
2. **devブランチとの差分確認**
3. **PR作成 (Closes #番号を含める)**

## Commands
```bash
# 現在のIssue確認
echo "Working on Issue: #$CURRENT_ISSUE"
gh issue view $CURRENT_ISSUE --json title,number

# コミット状況確認
git status
git log --oneline origin/dev..HEAD

# ブランチをプッシュ
git push -u origin $(git branch --show-current)

# PR作成 (Closes自動追加)
TITLE=$(gh issue view $CURRENT_ISSUE --json title -q .title)
gh pr create \
  --base dev \
  --title "$TITLE" \
  --body "## Summary
$(gh issue view $CURRENT_ISSUE --json body -q .body | head -3)

Closes #$CURRENT_ISSUE

## Changes
$(git diff origin/dev --name-only | head -10)

## Test
- [ ] Tests pass
- [ ] Lint pass"
```

## 注意
- 必ず`Closes #$CURRENT_ISSUE`を含める
- devブランチをターゲットにする
