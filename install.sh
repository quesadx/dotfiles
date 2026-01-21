#!/bin/bash

# CachyOS + Hyprland Dotfiles Installation Script
# This script uses GNU Stow to symlink configuration files

set -e

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

# Array of packages to install
packages=(
    "hyprland"
    "waybar"
    "scripts"
    "themes"
    "wallpapers"
)


# Stow each package
for pkg in "${packages[@]}"; do
    if [ -d "$pkg" ]; then
        stow -R "$pkg"
    else
        echo "Package $pkg not found, skipping..."
    fi
done

