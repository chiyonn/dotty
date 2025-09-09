#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dictionary
# @raycast.mode silent
# @raycast.packageName Dictionary

# Optional parameters:
# @raycast.icon 📖
# @raycast.argument1 { "type": "text", "placeholder": "Word to search" }
# @raycast.alias dict

# Documentation:
# @raycast.description Open Dictionary.app and search for a word
# @raycast.author chiyonn

word="$1"

if [ -z "$word" ]; then
    echo "Please provide a word to search"
    exit 1
fi

# Open Dictionary.app with the search word
open "dict://$word"