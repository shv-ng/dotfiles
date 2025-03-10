#!/bin/bash

[ "$(hyprctl activeworkspace -j | jq -r .id)" = "1" ] && kitty tmux new-session -A -s kitty-main || kitty
