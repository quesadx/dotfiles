#!/usr/bin/env bash

# Print the current theme (used by Waybar's exec, must not change state)
THEME_FILE="$HOME/dotfiles/themes/current-theme.txt"
current_theme=$(cat "$THEME_FILE" 2>/dev/null)
if [ -z "$current_theme" ]; then
    current_theme="DEFAULT" # Pretty much an error
fi

echo "$current_theme"
