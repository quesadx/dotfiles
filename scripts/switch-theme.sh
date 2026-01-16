#!/bin/bash

# Usage: ./switch-theme.sh

THEMES=("orange" "cyan")
THEME_FILE="$HOME/dotfiles/themes/current-theme.txt"

# Read current theme from file, default to "orange" if empty/missing
current_theme=$(cat "$THEME_FILE" 2>/dev/null)
if [ -z "$current_theme" ]; then
    current_theme="orange"
fi

# Find index of the current theme
idx=0
for i in "${!THEMES[@]}"; do
    if [ "${THEMES[$i]}" = "$current_theme" ]; then
        idx=$i
        break
    fi
done

# Compute next index and theme (wrap with modulo to stay in bounds)
len=${#THEMES[@]}
next_index=$(( (idx + 1) % len ))
next_theme=${THEMES[$next_index]}

THEME_PATH="$HOME/dotfiles/themes/$next_theme"
[ ! -d "$THEME_PATH" ] && exit 0

ln -sf "$THEME_PATH/look_and_feel.conf" "$HOME/dotfiles/hypr/look_and_feel.conf"
ln -sf "$THEME_PATH/waybar-style.css" "$HOME/dotfiles/waybar/style.css"
ln -sf "$THEME_PATH/rofi-config.rasi" "$HOME/dotfiles/rofi/config.rasi"
ln -sf "$THEME_PATH/fastfetch-config.jsonc" "$HOME/dotfiles/fastfetch/config.jsonc"
ln -sf "$THEME_PATH/kitty.conf" "$HOME/dotfiles/kitty/kitty.conf"
ln -sf "$THEME_PATH/wlogout-style.css" "$HOME/dotfiles/wlogout/style.css"
ln -sf "$THEME_PATH/fuzzel-themed.ini" "$HOME/dotfiles/fuzzel/fuzzel.ini"

echo "$next_theme" > "$THEME_FILE"
echo "$next_theme" # for waybar (it grabs the last stdout)

hyprctl reload >/dev/null 2>&1 || true
pkill waybar >/dev/null 2>&1 || true
waybar &
