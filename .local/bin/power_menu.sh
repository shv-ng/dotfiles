#!/bin/bash

# ----------------------------
# Configuration
# ----------------------------
AUTO_LOGIN_DIR="/etc/systemd/system/getty@tty1.service.d"
AUTO_LOGIN_FILE="$AUTO_LOGIN_DIR/autologin.conf"

OPTIONS=( "Hibernate" "Power off" "Suspend-Then-Hibernate" "Restart" "Suspend" "Enable autologin" "Disable autologin")

# ----------------------------
# Helper functions
# ----------------------------

# Check if autologin file exists
check_autologin_file() {
  if [[ ! -f "$AUTO_LOGIN_FILE" ]]; then
    notify-send "No autologin file found, create it first" -u critical
    exit 1
  fi
}

# Get autologin status: returns "on" or "off"
get_autologin_status() {
  if [[ ! -f "$AUTO_LOGIN_FILE" ]]; then
    echo "unknown"
  else
    local count_hash
    count_hash=$(rg -c "#" "$AUTO_LOGIN_FILE")
    [[ $count_hash -gt 0 ]] && echo "off" || echo "on"
  fi
}

# Enable autologin
enable_autologin() {
  check_autologin_file
  if [[ $(get_autologin_status) == "off" ]]; then
    sudo sed -i "s/#//g" "$AUTO_LOGIN_FILE"
    sudo systemctl daemon-reload
    notify-send "Autologin enabled"
  else
    notify-send "Autologin already enabled"
  fi
}

# Disable autologin
disable_autologin() {
  check_autologin_file
  if [[ $(get_autologin_status) == "on" ]]; then
    sudo sed -i "s/ExecStart/#ExecStart/g" "$AUTO_LOGIN_FILE"
    sudo systemctl daemon-reload
    notify-send "Autologin disabled"
  else
    notify-send "Autologin already disabled"
  fi
}

# Power actions
suspend-then-hibernate() { sudo systemctl suspend-then-hibernate; }
hibernate() { systemctl hibernate; }
poweroff() { systemctl poweroff; }
restart() { systemctl reboot; }
suspend() { systemctl suspend; }

# ----------------------------
# Main
# ----------------------------
AUTO_LOGIN_MESSAGE="(Autologin: $(get_autologin_status))"

selection=$(printf "%s\n" "${OPTIONS[@]}" | fzf --prompt="$AUTO_LOGIN_MESSAGE Select an action: " --layout reverse --border)

case "$selection" in
  "Suspend-Then-Hibernate") suspend-then-hibernate ;;
  "Hibernate") hibernate ;;
  "Power off") poweroff ;;
  "Restart") restart ;;
  "Suspend") suspend ;;
  "Enable autologin") enable_autologin ;;
  "Disable autologin") disable_autologin ;;
  *) exit 0 ;;
esac
