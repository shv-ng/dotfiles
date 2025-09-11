#!/bin/bash

# Enhanced Network Monitor Script
# Usage: ./netmon.sh [interface] [interval] [--detailed] [--log] [--help]

# Default values
INTERFACE=""
INTERVAL=1
DETAILED=false
LOG_FILE=""
SHOW_HELP=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to show help
show_help() {
    echo "Enhanced Network Monitor"
    echo "Usage: $0 [interface] [options]"
    echo ""
    echo "Options:"
    echo "  -i, --interface IFACE    Network interface to monitor (default: auto-detect)"
    echo "  -t, --interval SECONDS   Update interval in seconds (default: 1)"
    echo "  -d, --detailed          Show detailed statistics"
    echo "  -l, --log FILE          Log output to file"
    echo "  -h, --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                      # Monitor primary interface"
    echo "  $0 -i eth0 -t 2         # Monitor eth0 every 2 seconds"
    echo "  $0 --detailed --log net.log  # Detailed mode with logging"
    echo ""
    echo "Key bindings during execution:"
    echo "  q - Quit"
    echo "  r - Reset counters"
    echo "  d - Toggle detailed view"
    echo "  c - Clear screen"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--interface)
            INTERFACE="$2"
            shift 2
            ;;
        -t|--interval)
            INTERVAL="$2"
            shift 2
            ;;
        -d|--detailed)
            DETAILED=true
            shift
            ;;
        -l|--log)
            LOG_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            if [[ -z "$INTERFACE" && "$1" != -* ]]; then
                INTERFACE="$1"
            else
                echo "Unknown option: $1"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Function to get active network interface
get_primary_interface() {
    # Try to get the interface with default route
    local iface=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'dev \K\w+' | head -1)
    if [[ -n "$iface" ]]; then
        echo "$iface"
        return
    fi
    
    # Fallback: get first active interface (excluding loopback)
    local iface=$(ip link show | grep -E "state UP" | grep -v "lo:" | head -1 | cut -d: -f2 | tr -d ' ')
    if [[ -n "$iface" ]]; then
        echo "$iface"
        return
    fi
    
    # Last resort: common interface names
    for iface in wlan0 eth0 enp0s3 wlp2s0; do
        if [[ -e "/sys/class/net/$iface" ]]; then
            echo "$iface"
            return
        fi
    done
    
    echo ""
}

# Auto-detect interface if not specified
if [[ -z "$INTERFACE" ]]; then
    INTERFACE=$(get_primary_interface)
    if [[ -z "$INTERFACE" ]]; then
        echo "Error: No active network interface found!"
        echo "Available interfaces:"
        ls /sys/class/net/ | grep -v lo
        exit 1
    fi
fi

# Verify interface exists
if [[ ! -e "/sys/class/net/$INTERFACE" ]]; then
    echo "Error: Interface '$INTERFACE' not found!"
    echo "Available interfaces:"
    ls /sys/class/net/ | grep -v lo
    exit 1
fi

# Function to get interface statistics
get_stats() {
    local iface="$1"
    local stats_file="/proc/net/dev"
    
    if [[ ! -r "$stats_file" ]]; then
        echo "Error: Cannot read $stats_file"
        exit 1
    fi
    
    local line=$(grep "$iface:" "$stats_file")
    if [[ -z "$line" ]]; then
        echo "Error: Interface $iface not found in $stats_file"
        exit 1
    fi
    
    # Parse the line (remove interface name and colon)
    local stats=$(echo "$line" | sed "s/.*${iface}://" | awk '{print $1,$2,$3,$4,$9,$10,$11,$12}')
    echo "$stats"
}

# Function to get interface info
get_interface_info() {
    local iface="$1"
    local ip_addr=$(ip addr show "$iface" 2>/dev/null | grep "inet " | awk '{print $2}' | head -1)
    local mac_addr=$(cat "/sys/class/net/$iface/address" 2>/dev/null)
    local mtu=$(cat "/sys/class/net/$iface/mtu" 2>/dev/null)
    local speed=""
    
    # Try to get link speed
    if [[ -r "/sys/class/net/$iface/speed" ]]; then
        local speed_val=$(cat "/sys/class/net/$iface/speed" 2>/dev/null)
        if [[ "$speed_val" != "-1" && "$speed_val" =~ ^[0-9]+$ ]]; then
            speed="${speed_val}Mbps"
        fi
    fi
    
    echo "$ip_addr|$mac_addr|$mtu|$speed"
}

# Function to format bytes
format_bytes() {
    local bytes=$1
    if [[ $bytes -ge 1073741824 ]]; then
        printf "%.2f GB" $(echo "scale=2; $bytes/1073741824" | bc -l 2>/dev/null || echo "$bytes/1073741824")
    elif [[ $bytes -ge 1048576 ]]; then
        printf "%.2f MB" $(echo "scale=2; $bytes/1048576" | bc -l 2>/dev/null || echo "$bytes/1048576")
    elif [[ $bytes -ge 1024 ]]; then
        printf "%.2f KB" $(echo "scale=2; $bytes/1024" | bc -l 2>/dev/null || echo "$bytes/1024")
    else
        printf "%d B" "$bytes"
    fi
}

# Function to format speed
format_speed() {
    local bps=$1
    if [[ $bps -ge 1048576 ]]; then
        printf "%.2f MB/s" $(echo "scale=2; $bps/1048576" | bc -l 2>/dev/null || echo "$bps/1048576")
    elif [[ $bps -ge 1024 ]]; then
        printf "%.2f KB/s" $(echo "scale=2; $bps/1024" | bc -l 2>/dev/null || echo "$bps/1024")
    else
        printf "%d B/s" "$bps"
    fi
}

# Function to get system uptime
get_uptime() {
    local uptime_sec=$(cat /proc/uptime | cut -d' ' -f1 | cut -d'.' -f1)
    local days=$((uptime_sec / 86400))
    local hours=$(((uptime_sec % 86400) / 3600))
    local minutes=$(((uptime_sec % 3600) / 60))
    printf "%dd %02dh %02dm" "$days" "$hours" "$minutes"
}

# Function to log data
log_data() {
    if [[ -n "$LOG_FILE" ]]; then
        echo "$1" >> "$LOG_FILE"
    fi
}

# Trap signals for clean exit
trap 'echo -e "\n${GREEN}Monitoring stopped.${NC}"; exit 0' SIGINT SIGTERM

# Set up non-blocking input
if command -v stty >/dev/null 2>&1; then
    stty -echo -icanon time 0 min 0 2>/dev/null || true
fi

# Initialize variables
START_TIME=$(date +%s)
RESET_TIME=$START_TIME
MAX_DOWN_SPEED=0
MAX_UP_SPEED=0
TOTAL_DOWN_SESSION=0
TOTAL_UP_SESSION=0

# Get interface information
IFS='|' read -r IP_ADDR MAC_ADDR MTU LINK_SPEED <<< "$(get_interface_info "$INTERFACE")"

# Initial header
clear
echo -e "${BOLD}${BLUE}=== Enhanced Network Monitor ===${NC}"
echo -e "${CYAN}Interface: ${YELLOW}$INTERFACE${NC}"
[[ -n "$IP_ADDR" ]] && echo -e "${CYAN}IP Address: ${YELLOW}$IP_ADDR${NC}"
[[ -n "$MAC_ADDR" ]] && echo -e "${CYAN}MAC Address: ${YELLOW}$MAC_ADDR${NC}"
[[ -n "$MTU" ]] && echo -e "${CYAN}MTU: ${YELLOW}$MTU${NC}"
[[ -n "$LINK_SPEED" ]] && echo -e "${CYAN}Link Speed: ${YELLOW}$LINK_SPEED${NC}"
echo -e "${CYAN}Update Interval: ${YELLOW}${INTERVAL}s${NC}"
echo -e "${CYAN}Started: ${YELLOW}$(date)${NC}"
[[ -n "$LOG_FILE" ]] && echo -e "${CYAN}Logging to: ${YELLOW}$LOG_FILE${NC}"
echo ""
echo -e "${PURPLE}Press 'q' to quit, 'r' to reset, 'd' to toggle detailed view, 'c' to clear${NC}"
echo ""

# Get initial stats
IFS=' ' read -r RX_BYTES1 RX_PACKETS1 RX_ERRORS1 RX_DROPPED1 TX_BYTES1 TX_PACKETS1 TX_ERRORS1 TX_DROPPED1 <<< "$(get_stats "$INTERFACE")"

sleep "$INTERVAL"

# Main monitoring loop
while true; do
    # Get current stats
    IFS=' ' read -r RX_BYTES2 RX_PACKETS2 RX_ERRORS2 RX_DROPPED2 TX_BYTES2 TX_PACKETS2 TX_ERRORS2 TX_DROPPED2 <<< "$(get_stats "$INTERFACE")"
    
    # Calculate deltas
    RX_DIFF=$((RX_BYTES2 - RX_BYTES1))
    TX_DIFF=$((TX_BYTES2 - TX_BYTES1))
    RX_PACKETS_DIFF=$((RX_PACKETS2 - RX_PACKETS1))
    TX_PACKETS_DIFF=$((TX_PACKETS2 - TX_PACKETS1))
    
    # Calculate speeds (bytes per second)
    DOWN_SPEED=$((RX_DIFF / INTERVAL))
    UP_SPEED=$((TX_DIFF / INTERVAL))
    
    # Update maximums
    [[ $DOWN_SPEED -gt $MAX_DOWN_SPEED ]] && MAX_DOWN_SPEED=$DOWN_SPEED
    [[ $UP_SPEED -gt $MAX_UP_SPEED ]] && MAX_UP_SPEED=$UP_SPEED
    
    # Update session totals
    TOTAL_DOWN_SESSION=$((TOTAL_DOWN_SESSION + RX_DIFF))
    TOTAL_UP_SESSION=$((TOTAL_UP_SESSION + TX_DIFF))
    
    # Calculate session duration
    CURRENT_TIME=$(date +%s)
    SESSION_DURATION=$((CURRENT_TIME - RESET_TIME))
    
    # Format output
    TIMESTAMP=$(date '+%H:%M:%S')
    DOWN_FORMATTED=$(format_speed "$DOWN_SPEED")
    UP_FORMATTED=$(format_speed "$UP_SPEED")
    
    # Create status line
    STATUS_LINE="[$TIMESTAMP] "
    
    # Color code speeds
    if [[ $DOWN_SPEED -gt 1048576 ]]; then
        STATUS_LINE+="${GREEN}↓ $DOWN_FORMATTED${NC}"
    elif [[ $DOWN_SPEED -gt 10240 ]]; then
        STATUS_LINE+="${YELLOW}↓ $DOWN_FORMATTED${NC}"
    else
        STATUS_LINE+="↓ $DOWN_FORMATTED"
    fi
    
    STATUS_LINE+=" | "
    
    if [[ $UP_SPEED -gt 1048576 ]]; then
        STATUS_LINE+="${GREEN}↑ $UP_FORMATTED${NC}"
    elif [[ $UP_SPEED -gt 10240 ]]; then
        STATUS_LINE+="${YELLOW}↑ $UP_FORMATTED${NC}"
    else
        STATUS_LINE+="↑ $UP_FORMATTED"
    fi
    
    # Add packet rate
    STATUS_LINE+=" | Packets: ↓${RX_PACKETS_DIFF}/s ↑${TX_PACKETS_DIFF}/s"
    
    # Print current status
    printf "\r\033[K%b" "$STATUS_LINE"
    
    # Show detailed view if enabled
    if [[ "$DETAILED" == true ]]; then
        printf "\n"
        echo -e "${BOLD}=== Detailed Statistics ===${NC}"
        echo -e "${CYAN}Current Session ($(printf "%02d:%02d:%02d" $((SESSION_DURATION/3600)) $(((SESSION_DURATION%3600)/60)) $((SESSION_DURATION%60)))): ${NC}"
        echo -e "  Total Downloaded: ${GREEN}$(format_bytes $TOTAL_DOWN_SESSION)${NC}"
        echo -e "  Total Uploaded:   ${GREEN}$(format_bytes $TOTAL_UP_SESSION)${NC}"
        echo -e "  Peak Download:    ${YELLOW}$(format_speed $MAX_DOWN_SPEED)${NC}"
        echo -e "  Peak Upload:      ${YELLOW}$(format_speed $MAX_UP_SPEED)${NC}"
        
        echo -e "\n${CYAN}Total Interface Statistics:${NC}"
        echo -e "  RX Bytes:    ${GREEN}$(format_bytes $RX_BYTES2)${NC}"
        echo -e "  TX Bytes:    ${GREEN}$(format_bytes $TX_BYTES2)${NC}"
        echo -e "  RX Packets:  ${PURPLE}$RX_PACKETS2${NC}"
        echo -e "  TX Packets:  ${PURPLE}$TX_PACKETS2${NC}"
        
        if [[ $RX_ERRORS2 -gt 0 || $TX_ERRORS2 -gt 0 || $RX_DROPPED2 -gt 0 || $TX_DROPPED2 -gt 0 ]]; then
            echo -e "\n${RED}Error Statistics:${NC}"
            [[ $RX_ERRORS2 -gt 0 ]] && echo -e "  RX Errors:   ${RED}$RX_ERRORS2${NC}"
            [[ $TX_ERRORS2 -gt 0 ]] && echo -e "  TX Errors:   ${RED}$TX_ERRORS2${NC}"
            [[ $RX_DROPPED2 -gt 0 ]] && echo -e "  RX Dropped:  ${RED}$RX_DROPPED2${NC}"
            [[ $TX_DROPPED2 -gt 0 ]] && echo -e "  TX Dropped:  ${RED}$TX_DROPPED2${NC}"
        fi
        
        # Network load bar
        echo -e "\n${CYAN}Network Load:${NC}"
        local max_speed=$((MAX_DOWN_SPEED > MAX_UP_SPEED ? MAX_DOWN_SPEED : MAX_UP_SPEED))
        if [[ $max_speed -gt 0 ]]; then
            local down_pct=$((DOWN_SPEED * 50 / max_speed))
            local up_pct=$((UP_SPEED * 50 / max_speed))
            
            printf "  Download: ["
            for ((i=0; i<50; i++)); do
                if [[ $i -lt $down_pct ]]; then
                    printf "${GREEN}█${NC}"
                else
                    printf "░"
                fi
            done
            printf "] %s\n" "$(format_speed $DOWN_SPEED)"
            
            printf "  Upload:   ["
            for ((i=0; i<50; i++)); do
                if [[ $i -lt $up_pct ]]; then
                    printf "${BLUE}█${NC}"
                else
                    printf "░"
                fi
            done
            printf "] %s\n" "$(format_speed $UP_SPEED)"
        fi
        
        # System information
        echo -e "\n${CYAN}System Information:${NC}"
        echo -e "  Uptime: $(get_uptime)"
        if command -v free >/dev/null 2>&1; then
            local mem_info=$(free -h | grep "Mem:" | awk '{print $3"/"$2" ("$3/$2*100"%)"}' 2>/dev/null || echo "N/A")
            echo -e "  Memory: $mem_info"
        fi
        
        # Active connections
        if command -v netstat >/dev/null 2>&1; then
            local connections=$(netstat -tn 2>/dev/null | grep ESTABLISHED | wc -l)
            echo -e "  Active TCP Connections: $connections"
        elif command -v ss >/dev/null 2>&1; then
            local connections=$(ss -tn state established 2>/dev/null | wc -l)
            echo -e "  Active TCP Connections: $((connections - 1))"
        fi
        
        echo -e "\n${STATUS_LINE}"
        printf "\033[K"
    fi
    
    # Log data if enabled
    if [[ -n "$LOG_FILE" ]]; then
        log_data "$(date '+%Y-%m-%d %H:%M:%S'),$INTERFACE,$DOWN_SPEED,$UP_SPEED,$RX_BYTES2,$TX_BYTES2,$RX_PACKETS2,$TX_PACKETS2"
    fi
    
    # Check for user input
    if command -v stty >/dev/null 2>&1; then
        local input
        read -t 0.1 input 2>/dev/null || true
        case "$input" in
            q|Q)
                echo -e "\n${GREEN}Monitoring stopped.${NC}"
                exit 0
                ;;
            r|R)
                RESET_TIME=$(date +%s)
                MAX_DOWN_SPEED=0
                MAX_UP_SPEED=0
                TOTAL_DOWN_SESSION=0
                TOTAL_UP_SESSION=0
                echo -e "\n${YELLOW}Counters reset!${NC}"
                ;;
            d|D)
                DETAILED=$(!$DETAILED)
                clear
                ;;
            c|C)
                clear
                ;;
        esac
    fi
    
    # Update previous values
    RX_BYTES1=$RX_BYTES2
    TX_BYTES1=$TX_BYTES2
    RX_PACKETS1=$RX_PACKETS2
    TX_PACKETS1=$TX_PACKETS2
    
    sleep "$INTERVAL"
done
