#!/bin/bash

# Start swww daemon if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Set wallpaper with smooth animation
# Directory containing wallpapers
WALLPAPERS_DIR="$HOME/.config/hypr/wallpapers"

# Select a random wallpaper
WALLPAPER=$(find "$WALLPAPERS_DIR" -type f | shuf -n 1)

swww img "$WALLPAPER" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-fps 60 \
    --transition-step 90 \
    --transition-duration 2

