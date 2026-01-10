#!/bin/bash

# Start swww daemon if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Directory containing wallpapers
WALLPAPERS_DIR="$HOME/.config/hypr/wallpapers"
STATE_FILE="$HOME/.config/hypr/wallpapers/.current_wallpaper"

# Get list of wallpapers (sorted)
# Read into array properly handling spaces/newlines
mapfile -d '' WALLPAPERS < <(find "$WALLPAPERS_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) -print0 | sort -z)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    pgrep -x notify-send >/dev/null && notify-send "Wallpaper Error" "No wallpapers found under $WALLPAPERS_DIR"
    exit 1
fi

# Get current wallpaper path from state file
CURRENT_WALL=""
if [ -f "$STATE_FILE" ]; then
    CURRENT_WALL=$(cat "$STATE_FILE")
fi

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
NEXT_WALL="${WALLPAPERS[$NEXT_INDEX]}"

# Apply wallpaper
swww img "$NEXT_WALL" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-fps 60 \
    --transition-step 90 \
    --transition-duration 2

# Save state for next run
echo "$NEXT_WALL" > "$STATE_FILE"

