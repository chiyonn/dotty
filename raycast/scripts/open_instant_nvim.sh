#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Instant Nvim
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝
# @raycast.packageName Development

# Documentation:
# @raycast.description Opens nvim in Alacritty terminal (closes when nvim exits)
# @raycast.author chiyonn

# Open Alacritty with nvim and custom title for floating mode
/Applications/Alacritty.app/Contents/MacOS/alacritty -T "Instant Nvim" -e nvim &

# Wait a moment for the window to appear
sleep 0.5

# Make the window floating in AeroSpace
aerospace layout floating --window-id $(aerospace list-windows --all | grep "Instant Nvim" | head -1 | awk '{print $1}')