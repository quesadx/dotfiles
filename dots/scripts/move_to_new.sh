#!/bin/bash

# Get list of current workspace IDs
ids=$(hyprctl workspaces -j | jq '.[].id')

# Find the highest ID currently in use
max_id=$(echo "$ids" | sort -nr | head -n1)

# Determine the new workspace ID (Highest + 1)
# Use 1 if no workspaces found (start of session edge case)
if [[ -z "$max_id" ]]; then
    new_id=1
else
    new_id=$((max_id + 1))
fi

# Move the focused window to the new workspace
hyprctl dispatch movetoworkspace $new_id

# Focus the new workspace
hyprctl dispatch workspace $new_id

# Fullscreen the window
hyprctl dispatch fullscreen 0
