#!/bin/bash

# Usage: ./switch-theme.sh

THEMES=("orange" "cyan")
THEME_FILE="$HOME/.config/themes/current-theme.txt"

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

THEME_PATH="$HOME/.config/themes/$next_theme"
[ ! -d "$THEME_PATH" ] && exit 0

# Create config directories if they don't exist
mkdir -p "$HOME/.config/rofi" "$HOME/.config/fastfetch" "$HOME/.config/kitty" \
         "$HOME/.config/wlogout" "$HOME/.config/fuzzel" "$HOME/.config/swaync"

# Link theme files directly to .config locations
ln -sf "$THEME_PATH/look_and_feel.conf" "$HOME/.config/hypr/look_and_feel.conf"
ln -sf "$THEME_PATH/waybar-style.css" "$HOME/.config/waybar/style.css"
ln -sf "$THEME_PATH/rofi-config.rasi" "$HOME/.config/rofi/config.rasi"
ln -sf "$THEME_PATH/fastfetch-config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
ln -sf "$THEME_PATH/kitty.conf" "$HOME/.config/kitty/kitty.conf"
ln -sf "$THEME_PATH/wlogout-style.css" "$HOME/.config/wlogout/style.css"
ln -sf "$THEME_PATH/fuzzel-themed.ini" "$HOME/.config/fuzzel/fuzzel.ini"

# If the theme provides a swaync style.css, link it
if [ -f "$THEME_PATH/swaync.style.css" ]; then
    ln -sf "$THEME_PATH/swaync.style.css" "$HOME/.config/swaync/style.css"
fi

echo "$next_theme" > "$THEME_FILE"
echo "$next_theme" # for waybar (it grabs the last stdout)

hyprctl reload >/dev/null 2>&1 || true
pkill waybar >/dev/null 2>&1 || true
waybar &
# Reload swaync CSS to apply new theme
swaync-client -rs >/dev/null 2>&1 || true
