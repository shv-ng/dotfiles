#!/bin/bash

#!/bin/bash
if grep -q "enabled = false" ~/.config/hypr/conf/devices.conf; then
    sed -i 's/enabled = false/enabled = true/' ~/.config/hypr/conf/devices.conf
    notify-send "Touchpad enabled"
else
    sed -i 's/enabled = true/enabled = false/' ~/.config/hypr/conf/devices.conf
    notify-send "Touchpad disabled"
fi
hyprctl reload
