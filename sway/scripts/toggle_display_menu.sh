#!/bin/bash

choice=$(printf "Sitting\nLaydown" | wofi --dmenu --prompt "Display Mode:")

case "$choice" in
  Sitting)
    $HOME/.config/sway/scripts/sitting_layout.sh
    ;;
  Laydown)
    $HOME/.config/sway/scripts/laydown_layout.sh
    ;;
esac
