#!/bin/bash

SESSION_NAME="${1:-home}"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux attach -t "$SESSION_NAME"
  exit 0
fi

# 新しいセッションをデタッチ状態で開始（最初のペイン: 左上）
tmux new-session -d -s "$SESSION_NAME"

# 左上を選択（初期ペイン）
tmux select-pane -t "$SESSION_NAME:0.0"

# 左下を作成（上下分割）
tmux split-window -v -t "$SESSION_NAME:0.0"

# 左下（下側）で htop 実行
tmux send-keys -t "$SESSION_NAME:0.1" 'htop' C-m

# 左ペイン（上下分割された2ペイン）を横に分割して右側（nvim用）を作成
tmux select-pane -t "$SESSION_NAME:0.0"
tmux split-window -h -t "$SESSION_NAME:0.0"

# 右側で nvim 実行
tmux send-keys -t "$SESSION_NAME:0.2" 'nvim' C-m

# 左上にフォーカスを戻す
tmux select-pane -t "$SESSION_NAME:0.0"

# ウィンドウ名を変更
tmux rename-window -t "$SESSION_NAME:0" "dashboard"

# セッションにアタッチ
tmux attach -t "$SESSION_NAME"
