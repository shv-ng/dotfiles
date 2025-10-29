#!/bin/bash

# Get the current gaps_in value
CURRENT_GAPS=$(hyprctl getoption general:gaps_in | awk 'NR==1 {print $3}')

if [ "$CURRENT_GAPS" = "0" ]; then
    # Enable gaps, borders, and colors
    hyprctl --batch "
        keyword general:gaps_in 5;
        keyword general:gaps_out 20;
        keyword general:border_size 2;
        keyword decoration:rounding 10;
        keyword decoration:drop_shadow true;
        keyword decoration:col.active_border rgba(33ccffee) rgba(00ff99ee) 45deg;
        keyword decoration:col.inactive_border rgba(595959aa);
    "
else
    # Disable gaps and borders
    hyprctl --batch "
        keyword general:gaps_in 0;
        keyword general:gaps_out 0;
        keyword general:border_size 0;
        keyword decoration:rounding 0;
        keyword decoration:drop_shadow false;
    "
fi
