#!/bin/bash

# Uninstall script - removes all symlinks created by stow

set -e

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

echo "🗑️  Uninstalling dotfiles..."
echo ""

packages=(
    "hyprland"
    "waybar"
    "scripts"
    "themes"
    "wallpapers"
    "home"
)

for pkg in "${packages[@]}"; do
    if [ -d "$pkg" ]; then
        echo "📦 Unlinking $pkg..."
        stow -D "$pkg"
    fi
done

echo ""
echo "✅ Dotfiles uninstalled successfully!"
