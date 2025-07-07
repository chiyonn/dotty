#!/bin/bash

SESSION_NAME="${1:-home}"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux attach -t "$SESSION_NAME"
  exit 0
fi

tmux new-session -d -s "$SESSION_NAME"

tmux split-window -h -t "$SESSION_NAME"

tmux split-window -v -t "$SESSION_NAME:0.0"

tmux send-keys -t "$SESSION_NAME:0.0" 'htop' C-m
tmux send-keys -t "$SESSION_NAME:0.1" 'nvim' C-m

tmux select-pane -t "$SESSION_NAME:0.2"

tmux rename-window -t "$SESSION_NAME:0" "dashboard"

tmux attach -t "$SESSION_NAME"


