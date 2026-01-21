#!/bin/bash

# Start swww daemon if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Directory containing wallpapers
WALLPAPERS_DIR="$HOME/.local/share/wallpapers"
STATE_FILE="$HOME/.cache/current_wallpaper"

# Get list of wallpapers using glob expansion (handles spaces)
shopt -s nullglob
WALLPAPERS=()
for ext in png jpg jpeg gif webp; do
    WALLPAPERS+=("$WALLPAPERS_DIR"/*."$ext")
done

# Sort the array
IFS=$'\n' WALLPAPERS=($(sort <<<"${WALLPAPERS[*]}"))
unset IFS

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Error" "No wallpapers found under $WALLPAPERS_DIR" 2>/dev/null
    exit 1
fi

# Get current wallpaper path from state file
CURRENT_WALL=""
if [ -f "$STATE_FILE" ]; then
    CURRENT_WALL=$(cat "$STATE_FILE")
fi

# Determine target wallpaper
TARGET_WALL=""

if [[ "$1" == "next" ]] || [[ -z "$CURRENT_WALL" ]]; then
    # Find index of current wallpaper in the list
    CURRENT_INDEX=-1
    for i in "${!WALLPAPERS[@]}"; do
       if [[ "${WALLPAPERS[$i]}" == "$CURRENT_WALL" ]]; then
           CURRENT_INDEX=$i
           break
       fi
    done

    # Calculate next index (cycling)
    NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))
    TARGET_WALL="${WALLPAPERS[$NEXT_INDEX]}"

    # Save state for next run
    echo "$TARGET_WALL" > "$STATE_FILE"
else
    TARGET_WALL="$CURRENT_WALL"
fi

# Apply wallpaper
swww img "$TARGET_WALL" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-fps 60 \
    --transition-step 90 \
    --transition-duration 1.5

