#!/bin/bash

# CachyOS + Hyprland Dotfiles Installation Script
# This script uses GNU Stow to symlink configuration files

set -e

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

echo "🔧 Installing dotfiles using GNU Stow..."
echo ""

# Array of packages to install
packages=(
    "hyprland"
    "waybar"
    "scripts"
    "themes"
    "wallpapers"
)

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "❌ GNU Stow is not installed!"
    echo "Install it with: sudo pacman -S stow"
    exit 1
fi

# Stow each package
for pkg in "${packages[@]}"; do
    if [ -d "$pkg" ]; then
        echo "📦 Linking $pkg..."
        stow -R "$pkg"
    else
        echo "⚠️  Package $pkg not found, skipping..."
    fi
done

echo ""
echo "✅ Dotfiles installed successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Make sure scripts are executable: chmod +x ~/.local/bin/*"
echo "   2. Reload Hyprland: hyprctl reload"
echo "   3. Switch themes: switch-theme.sh"
echo ""
