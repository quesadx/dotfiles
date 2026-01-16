#!/bin/bash

# Usage: ./switch-theme.sh <theme-name>
# AThemes: orange, cyan

THEME="${1:-orange}"
THEME_PATH="$HOME/dotfiles/themes/$THEME"

[ ! -d "$THEME_PATH" ] && exit 0

ln -sf "$THEME_PATH/look_and_feel.conf" "$HOME/dotfiles/hypr/look_and_feel.conf"
ln -sf "$THEME_PATH/waybar-style.css" "$HOME/dotfiles/waybar/style.css"
ln -sf "$THEME_PATH/rofi-config.rasi" "$HOME/dotfiles/rofi/config.rasi"
ln -sf "$THEME_PATH/fastfetch-config.jsonc" "$HOME/dotfiles/fastfetch/config.jsonc"
ln -sf "$THEME_PATH/kitty.conf" "$HOME/dotfiles/kitty/kitty.conf"
ln -sf "$THEME_PATH/wlogout-style.css" "$HOME/dotfiles/wlogout/style.css"

hyprctl reload 2>/dev/null || true
pkill waybar 2>/dev/null || true
sleep 0.3
waybar &
