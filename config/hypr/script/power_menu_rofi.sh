
#!/bin/bash

# Define the options for Rofi
options="Power off\nRestart\nSuspend"

# Display the options with Rofi and store the selected option
selection=$(echo -e "$options" | rofi -dmenu -p "Select an action")

# Execute commands based on the selected option
case "$selection" in
    "Power off")
        dunstify "Shutting down..."   # Notify before shutdown
        systemctl poweroff            # Shutdown command
        ;;
    "Restart")
        dunstify "Restarting..."      # Notify before restart
        systemctl reboot              # Restart command
        ;;
    "Suspend")
        dunstify "Suspending..."      # Notify before suspend
        systemctl suspend             # Suspend command
        ;;
    *)
        dunstify "Invalid selection or cancelled."  # Notify on invalid/cancelled selection
        ;;
esac
