---
name: next-approve
description: Start work on selected issue - update status to In Progress and create feature branch
---

# Next Approve

選択したIssueの作業開始 - ステータス更新とブランチ作成

## 実行手順
1. **環境変数にIssue番号を保存** (`export CURRENT_ISSUE=123`)
2. **devブランチを最新に更新**
3. **ステータスを"In Progress"に変更** (重要！他の人が着手しないように)
4. **featureブランチ作成**

## Commands
```bash
# Issue番号を環境変数に保存
export CURRENT_ISSUE=<number>
echo "export CURRENT_ISSUE=$CURRENT_ISSUE" >> ~/.zshrc  # 永続化

# devブランチ最新化
git checkout dev
git pull origin dev

# ステータス更新 (必須！)
# 1. まずIssueをProjectに追加
OWNER=$(gh repo view --json owner -q .owner.login)
ISSUE_URL=$(gh issue view $CURRENT_ISSUE --json url -q .url)
gh project item-add 4 --owner $OWNER --url $ISSUE_URL

# 2. GraphQL APIでステータスを"In Progress"に更新
# 注: Project番号とField IDは環境に合わせて調整が必要
gh api graphql -f query='
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwHOBrhoMc4BABfm"
    itemId: "(要取得)"
    fieldId: "PVTSSF_lAHOBrhoMc4BABfmzgy8-10"
    value: {singleSelectOptionId: "f75ad846"}
  }) {
    projectV2Item { id }
  }
}'

# 自分にアサイン
gh issue edit $CURRENT_ISSUE --add-assignee @me

# ブランチ作成
TITLE=$(gh issue view $CURRENT_ISSUE --json title -q .title | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | head -c 30)
git checkout -b "feature/#${CURRENT_ISSUE}-${TITLE}"
```

## 出力
- ✅ ステータス更新完了
- 🌿 ブランチ: feature/#123-xxx
- 📌 Issue: $CURRENT_ISSUE
