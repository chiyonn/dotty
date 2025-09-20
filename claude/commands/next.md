---
name: next
description: Select the most important TODO from GitHub Project with same name as repo/working dir
---

# Next Task

GitHub Projectから最優先タスクを1つ選択し、理由を説明

## 実行手順
1. リポジトリ名と同じGitHub Projectを特定
2. TODO statusのissueを取得
3. 優先度でスコアリング (critical/bug > blocker > age > comments)
4. 最高スコアのissueを選択

## Example
```bash
# プロジェクト名とTODO取得
PROJECT=$(basename $(pwd))
gh project item-list --owner $(gh repo view --json owner -q .owner.login) \
  --limit 100 --format json | \
  jq -r '.projects[] | select(.title == "'$PROJECT'") | .items[] | select(.status == "Todo")'

# Issue詳細取得
gh issue view <number> --json title,labels,body,comments
```

## 出力
- 選択理由 (2-3点)
- タスク概要 (1-2行)
