# Common aliases for both macOS and Linux

# Linux-specific ls aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lha'

# Git aliases
alias gb='git branch'
alias gl='git log'
alias gll='git log --oneline'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gd='git diff'

# Editor aliases
alias v=nvim

# Tmux aliases
alias t=tmux
alias tnew='tmux new-session -s'
alias attach='tmux attach -t'

# Python environment
alias activate='source ./.venv/bin/activate'