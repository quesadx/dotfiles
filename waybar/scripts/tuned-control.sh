#!/bin/bash

# Define Profiles
P_LOW="laptop-battery-powersave"
P_BAL="balanced"
P_HIGH="throughput-performance"
P_VM="virtual-host"

# Get current profile - trim output
CURRENT=$(tuned-adm active | sed 's/Current active profile: //' | xargs)

# Command handling
case "$1" in
    "get")
        if [[ "$CURRENT" == "$P_LOW" ]]; then
            TEXT="LP"
            CLASS="power-saver"
            TOOLTIP="Mode: Powersave ($CURRENT)"
        elif [[ "$CURRENT" == "$P_HIGH" ]]; then
            TEXT="HP"
            CLASS="performance"
            TOOLTIP="Mode: Performance ($CURRENT)"
        elif [[ "$CURRENT" == "$P_VM" ]]; then
            TEXT="VM"
            CLASS="performance"
            TOOLTIP="Mode: Virtual Host ($CURRENT)"
        else
            # Default to Balanced
            TEXT="B"
            CLASS="balanced"
            TOOLTIP="Mode: Balanced ($CURRENT)"
        fi
        
        # Output JSON for Waybar
        printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$TEXT" "$TOOLTIP" "$CLASS"
        ;;
        
    "toggle")
        # Define readable names
        NAME_LOW="Power Saver"
        NAME_BAL="Balanced"
        NAME_HIGH="Performance"
        NAME_VM="Virtual Host"

        # Build options list (mark current with *)
        OPTIONS=""
        [[ "$CURRENT" == "$P_LOW" ]] && OPTIONS="${NAME_LOW} (Current)\n" || OPTIONS="${OPTIONS}${NAME_LOW}\n"
        [[ "$CURRENT" == "$P_BAL" ]] && OPTIONS="${OPTIONS}${NAME_BAL} (Current)\n" || OPTIONS="${OPTIONS}${NAME_BAL}\n"
        [[ "$CURRENT" == "$P_HIGH" ]] && OPTIONS="${OPTIONS}${NAME_HIGH} (Current)\n" || OPTIONS="${OPTIONS}${NAME_HIGH}\n"
        [[ "$CURRENT" == "$P_VM" ]] && OPTIONS="${OPTIONS}${NAME_VM} (Current)" || OPTIONS="${OPTIONS}${NAME_VM}"

        # Clean trailing newline if any
        OPTIONS=$(echo -e "$OPTIONS" | sed '/^$/d')

        # Open Rofi
        CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Power Profile" \
            -config "$HOME/.config/rofi/tuned-selector.rasi")

        # Map choice to profile
        case "$CHOICE" in
            *"$NAME_LOW"*) NEXT="$P_LOW" ;;
            *"$NAME_BAL"*) NEXT="$P_BAL" ;;
            *"$NAME_HIGH"*) NEXT="$P_HIGH" ;;
            *"$NAME_VM"*) NEXT="$P_VM" ;;
            *) exit 0 ;; # Cancelled
        esac

        # If trying to switch to current, just exit
        if [[ "$NEXT" == "$CURRENT" ]]; then
            exit 0
        fi
        
        # Launch kitty with bash -c to keep window open on failure
        kitty --class floating_shell --title "Switch Power Profile" -e bash -c "echo 'Switching to $NEXT...'; echo 'Please enter your password for sudo:'; sudo tuned-adm profile '$NEXT'; STATUS=\$?; if [ \$STATUS -ne 0 ]; then echo; echo 'Authentication failed or Error occurred.'; echo 'Please check Caps Lock/Num Lock.'; read -p 'Press Enter to exit...' var; fi"
        ;;
esac
