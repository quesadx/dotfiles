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
# If the theme provides a swaync config, link it into dotfiles and ensure ~/.config points to it
if [ -f "$THEME_PATH/swaync.conf" ]; then
    ln -sf "$THEME_PATH/swaync.conf" "$HOME/dotfiles/swaync/config.conf"
    mkdir -p "$HOME/.config/swaync"
    ln -sf "$HOME/dotfiles/swaync/config.conf" "$HOME/.config/swaync/config.conf"
fi
# If the theme provides a swaync style.css, link it for user CSS overrides
if [ -f "$THEME_PATH/swaync.style.css" ]; then
    ln -sf "$THEME_PATH/swaync.style.css" "$HOME/dotfiles/swaync/style.css"
    mkdir -p "$HOME/.config/swaync"
    ln -sf "$HOME/dotfiles/swaync/style.css" "$HOME/.config/swaync/style.css"
fi

echo "$next_theme" > "$THEME_FILE"
echo "$next_theme" # for waybar (it grabs the last stdout)

hyprctl reload >/dev/null 2>&1 || true
pkill waybar >/dev/null 2>&1 || true
waybar &
# Restart swaync so it picks up the new user CSS
pkill swaync >/dev/null 2>&1 || true
swaync &
