#!/usr/bin/env bash
set -e

SINCE=${1:-"7 days ago"}
echo "Calculating uptime since: $SINCE"

TMP_LOG=$(mktemp)
TMP_TIMELINE=$(mktemp)
TMP_LOG_ALL=$(mktemp)

# Get all relevant events and combine them
journalctl --since="$SINCE" --no-pager | rg -i " mounted.*boot|unmounted.*boot|starting system suspend|systemd-suspend.service|The system will hibernate now|hibernation exit|starting system hybrid-sleep|systemd-hybrid-sleep.service" > "$TMP_LOG_ALL"

{
    # Power on events (boot mounted)
    rg -i " mounted.*boot" "$TMP_LOG_ALL" | sed 's/$/ POWER_ON/'
    
    # Power off events (boot unmounted)
    rg -i "unmounted.*boot" "$TMP_LOG_ALL" | sed 's/$/ POWER_OFF/'
    
    # Suspend events (going to sleep)
    rg -i "starting system suspend" "$TMP_LOG_ALL" | sed 's/$/ SUSPEND/'
    
    # Hibernation events (going to hibernation)
    rg -i "The system will hibernate now!" "$TMP_LOG_ALL" | sed 's/$/ HIBERNATE/'
    
    # Hybrid-sleep events (suspend + hibernate)
    rg -i "starting system hybrid-sleep" "$TMP_LOG_ALL" | sed 's/$/ HYBRID_SLEEP/'
    
    # Resume events (waking from sleep/hibernation/hybrid-sleep)
    rg -i "systemd-suspend.service|hibernation exit|systemd-hybrid-sleep.service" "$TMP_LOG_ALL" | rg -v "starting" | sed 's/$/ RESUME/'
} > "$TMP_LOG"

# Function to parse events into timeline
parse_events() {
    awk '
    {
        # Extract timestamp (first 3 fields: month day time)
        datetime = $1 " " $2 " " $3;
        
        # Get the event type (last field we added)
        event = $NF;
        
        print datetime " " event;
    }' "$TMP_LOG"
}

# Build clean event timeline and sort by time
TIMELINE=$(parse_events | sort -k1M -k2n -k3)

# Save timeline to temp file for processing
echo "$TIMELINE" > "$TMP_TIMELINE"

# Calculate screentime
calculate_screentime() {
    awk '
    BEGIN {
        total_seconds = 0
        active = 0
        last_active_time = ""
        
        print "Screentime Sessions:"
        print "==================="
    }
    
    {
        # Parse the timestamp and event
        month = $1
        day = $2
        time = $3
        event = $4
        
        # Convert to epoch time for calculation
        timestamp = month " " day " " time
        cmd = "date -d \"" timestamp "\" +%s"
        cmd | getline epoch
        close(cmd)
        
        # Events that start active time
        if (event == "POWER_ON" || event == "RESUME") {
            if (!active) {
                active = 1
                last_active_time = timestamp
                last_epoch = epoch
                printf "Started: %s\n", timestamp
            }
        }
        # Events that end active time
        else if (event == "POWER_OFF" || event == "SUSPEND" || event == "HIBERNATE" || event == "HYBRID_SLEEP") {
            if (active) {
                active = 0
                duration = epoch - last_epoch
                total_seconds += duration
                
                hours = int(duration / 3600)
                minutes = int((duration % 3600) / 60)
                seconds = duration % 60
                
                # Show what type of sleep/shutdown occurred
                sleep_type = ""
                if (event == "SUSPEND") sleep_type = " (Suspended)"
                else if (event == "HIBERNATE") sleep_type = " (Hibernated)"
                else if (event == "HYBRID_SLEEP") sleep_type = " (Hybrid Sleep)"
                else if (event == "POWER_OFF") sleep_type = " (Powered Off)"
                
                printf "Ended:   %s%s (Duration: %02d:%02d:%02d)\n", timestamp, sleep_type, hours, minutes, seconds
                printf "----------------------------------------\n"
            }
        }
    }
    
    END {
        # If still active, calculate time until now
        if (active) {
            cmd = "date +%s"
            cmd | getline current_epoch
            close(cmd)
            
            duration = current_epoch - last_epoch
            total_seconds += duration
            
            hours = int(duration / 3600)
            minutes = int((duration % 3600) / 60)
            seconds = duration % 60
            
            cmd = "date"
            cmd | getline current_time
            close(cmd)
            
            printf "Still active (Duration so far: %02d:%02d:%02d)\n", hours, minutes, seconds
            printf "----------------------------------------\n"
        }
        
        # Calculate total time
        total_days = int(total_seconds / 86400)
        remaining_after_days = total_seconds % 86400
        total_hours = int(remaining_after_days / 3600)
        remaining_after_hours = remaining_after_days % 3600
        total_minutes = int(remaining_after_hours / 60)
        remaining_seconds = remaining_after_hours % 60
        
        printf "\nTOTAL SCREENTIME: "
        if (total_days > 0) printf "%d days, ", total_days
        if (total_hours > 0) printf "%d hrs, ", total_hours
        if (total_minutes > 0) printf "%d mins, ", total_minutes
        if (remaining_seconds > 0) printf "%d sec", remaining_seconds
        printf "\n"
        
        printf "Total minutes: %.1f\n", total_seconds / 60
        printf "Total hours: %.2f\n", total_seconds / 3600
    }
    ' "$TMP_TIMELINE"
}

# Run the calculation
calculate_screentime

# Cleanup
rm "$TMP_LOG" "$TMP_TIMELINE" "$TMP_LOG_ALL"
