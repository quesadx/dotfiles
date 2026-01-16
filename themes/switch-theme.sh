#!/bin/bash

# Theme Switcher Script
# Usage: ./switch-theme.sh <theme-name>
# Available themes: dark-orange, cyan-neon

set -e

DOTFILES_DIR="$HOME/dotfiles"
THEMES_DIR="$DOTFILES_DIR/themes"
THEME="${1:-dark-orange}"
THEME_PATH="$THEMES_DIR/$THEME"
CONFIG_DIR="$HOME/.config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validate theme exists
if [ ! -d "$THEME_PATH" ]; then
    echo -e "${RED}Error: Theme '$THEME' not found!${NC}"
    echo -e "${YELLOW}Available themes:${NC}"
    ls "$THEMES_DIR"
    exit 1
fi

echo -e "${YELLOW}Switching to theme: ${GREEN}$THEME${NC}"

# Function to safely symlink a file
symlink_file() {
    local source="$1"
    local target="$2"
    
    if [ ! -f "$source" ]; then
        echo -e "${RED}Warning: Source file not found: $source${NC}"
        return 1
    fi
    
    # Backup original if not already a symlink
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        cp "$target" "$target.backup"
        echo -e "${YELLOW}Backed up original to: $target.backup${NC}"
    fi
    
    # Remove old symlink if it exists
    [ -L "$target" ] && rm "$target"
    
    # Create new symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}✓${NC} $target"
}

# Apply theme files
echo -e "\n${YELLOW}Applying theme files...${NC}"

# Hyprland look_and_feel
symlink_file "$THEME_PATH/look_and_feel.conf" "$CONFIG_DIR/hypr/look_and_feel.conf"

# Waybar styles
symlink_file "$THEME_PATH/waybar-style.css" "$CONFIG_DIR/waybar/style.css"

# Rofi config
symlink_file "$THEME_PATH/rofi-config.rasi" "$CONFIG_DIR/rofi/config.rasi"

# Fastfetch config
symlink_file "$THEME_PATH/fastfetch-config.jsonc" "$CONFIG_DIR/fastfetch/config.jsonc"

# Kitty config
symlink_file "$THEME_PATH/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf"

# Wlogout styles
symlink_file "$THEME_PATH/wlogout-style.css" "$CONFIG_DIR/wlogout/style.css"

echo -e "\n${YELLOW}Reloading services...${NC}"

# Reload Hyprland configuration
if command -v hyprctl &> /dev/null; then
    hyprctl reload
    echo -e "${GREEN}✓${NC} Hyprland reloaded"
fi

# Restart Waybar
if command -v waybar &> /dev/null; then
    killall waybar 2>/dev/null || true
    sleep 0.5
    waybar &
    echo -e "${GREEN}✓${NC} Waybar restarted"
fi

echo -e "\n${GREEN}Theme switched successfully!${NC}"
echo -e "${YELLOW}Current theme: ${GREEN}$THEME${NC}"
