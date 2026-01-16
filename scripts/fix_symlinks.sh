#!/bin/bash
set -e

# Define paths
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "🔧 Fixing symlinks for Waybar and other tools..."

# ensure .config exists
mkdir -p "$CONFIG_DIR"

# 1. Waybar
# Backup existing waybar config if it's a directory or file and not a symlink to our dotfiles
if [ -e "$CONFIG_DIR/waybar" ] && [ ! -L "$CONFIG_DIR/waybar" ]; then
    echo "Backing up existing waybar config to waybar.bak..."
    mv "$CONFIG_DIR/waybar" "$CONFIG_DIR/waybar.bak"
fi

# Remove broken symlink if exists
if [ -L "$CONFIG_DIR/waybar" ]; then
    rm "$CONFIG_DIR/waybar"
fi

# Link
echo "Linking $DOTFILES_DIR/waybar to $CONFIG_DIR/waybar..."
ln -s "$DOTFILES_DIR/waybar" "$CONFIG_DIR/waybar"

# 2. Hyprland
# Assuming hypr is already linked, but if not:
if [ ! -L "$CONFIG_DIR/hypr" ]; then
     echo "Note: Ensure $CONFIG_DIR/hypr is linked to $DOTFILES_DIR/hypr"
     # Optional: ln -s "$DOTFILES_DIR/hypr" "$CONFIG_DIR/hypr"
fi

# 3. Rofi
if [ -e "$CONFIG_DIR/rofi" ] && [ ! -L "$CONFIG_DIR/rofi" ]; then
    mv "$CONFIG_DIR/rofi" "$CONFIG_DIR/rofi.bak"
fi
if [ -L "$CONFIG_DIR/rofi" ]; then rm "$CONFIG_DIR/rofi"; fi
echo "Linking $DOTFILES_DIR/rofi to $CONFIG_DIR/rofi..."
ln -s "$DOTFILES_DIR/rofi" "$CONFIG_DIR/rofi"

# 4. Wlogout
if [ -e "$CONFIG_DIR/wlogout" ] && [ ! -L "$CONFIG_DIR/wlogout" ]; then
    mv "$CONFIG_DIR/wlogout" "$CONFIG_DIR/wlogout.bak"
fi
if [ -L "$CONFIG_DIR/wlogout" ]; then rm "$CONFIG_DIR/wlogout"; fi
echo "Linking $DOTFILES_DIR/wlogout to $CONFIG_DIR/wlogout..."
ln -s "$DOTFILES_DIR/wlogout" "$CONFIG_DIR/wlogout"

# 5. Fastfetch
if [ -e "$CONFIG_DIR/fastfetch" ] && [ ! -L "$CONFIG_DIR/fastfetch" ]; then
    mv "$CONFIG_DIR/fastfetch" "$CONFIG_DIR/fastfetch.bak"
fi
if [ -L "$CONFIG_DIR/fastfetch" ]; then rm "$CONFIG_DIR/fastfetch"; fi
echo "Linking $DOTFILES_DIR/fastfetch to $CONFIG_DIR/fastfetch..."
ln -s "$DOTFILES_DIR/fastfetch" "$CONFIG_DIR/fastfetch"

# 6. Kitty
if [ -e "$CONFIG_DIR/kitty" ] && [ ! -L "$CONFIG_DIR/kitty" ]; then
    mv "$CONFIG_DIR/kitty" "$CONFIG_DIR/kitty.bak"
fi
if [ -L "$CONFIG_DIR/kitty" ]; then rm "$CONFIG_DIR/kitty"; fi
echo "Linking $DOTFILES_DIR/kitty to $CONFIG_DIR/kitty..."
ln -s "$DOTFILES_DIR/kitty" "$CONFIG_DIR/kitty"


echo "✅ Symlinks fixed! Please restart Hyprland or reload configs."
