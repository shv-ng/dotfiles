#!/bin/bash

LINK_FILE="$HOME/.config/hypr/scripts/my_links.csv"

website=$(cat "$LINK_FILE" | fzf --layout reverse)
url=$(echo "$website" | cut -d ',' -f2)
[ -z "$website" ] && exit 0


nohup brave "$url" --password-store=basic --enable-features=WebRTCPipeWireCapturer --ozone-platform=wayland > /dev/null 2>&1 &
# nohup firefox "$url" > /dev/null 2>&1 &
hyprctl dispatch workspace 2
