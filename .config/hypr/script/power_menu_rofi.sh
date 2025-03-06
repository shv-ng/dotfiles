
#!/bin/bash

# Define the options for Rofi
options="Power off\nRestart\nSuspend"

# Display the options with Rofi and store the selected option
selection=$(echo -e "$options" | rofi -dmenu -p "Select an action")

# Execute commands based on the selected option
case "$selection" in
    "Power off")
        systemctl poweroff            # Shutdown command
        ;;
    "Restart")
        systemctl reboot              # Restart command
        ;;
    "Suspend")
        systemctl suspend             # Suspend command
        ;;
    *)
esac
