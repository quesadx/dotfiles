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
    "home"
)


# Stow each package
for pkg in "${packages[@]}"; do
    if [ "$pkg" = "home" ] && [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
        timestamp=$(date +%Y%m%d%H%M%S)
        backup="$HOME/.bashrc.backup.$timestamp"
        echo "Found existing ~/.bashrc — backing up to $backup"
        mv "$HOME/.bashrc" "$backup"
    fi

    if [ -d "$pkg" ]; then
        stow -R "$pkg"
    else
        echo "Package $pkg not found, skipping..."
    fi
done

