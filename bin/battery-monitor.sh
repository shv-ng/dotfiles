#!/bin/bash

MAX_BATTERY_LEVEL=95
MIN_BATTERY_LEVEL=25
CHECK_INTERVAL=150

while true; do
  BATTERY_PERCENT=$(acpi | awk '{print $4}' | rg -o "[0-9]+")

  if acpi | rg -q "Discharging"; then
    if [[ $BATTERY_PERCENT -lt $MIN_BATTERY_LEVEL ]]; then
      notify-send -u critical -i battery-low "⚠️ Battery Low!" \
        "Bhai, charger lga le! 📉\nBattery: $BATTERY_PERCENT% (Below $MIN_BATTERY_LEVEL%)"
    fi
  else
    if [[ $BATTERY_PERCENT -gt $MAX_BATTERY_LEVEL ]]; then
      notify-send -u normal -i battery-full "🔌 Unplug Charger!" \
        "Bhai, kitna charge karega? ⚡\nBattery: $BATTERY_PERCENT% (Reached $MAX_BATTERY_LEVEL%)"
    fi
  fi
  sleep $CHECK_INTERVAL
done
