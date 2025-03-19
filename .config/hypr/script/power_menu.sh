#!/bin/bash

options="Power off\nRestart\nSuspend\nEnable autologin\nDisable autologin"

AUTO_LOGIN_DIR="/etc/systemd/system/getty@tty1.service.d"
AUTO_LOGIN_FILE="$AUTO_LOGIN_DIR/autologin.conf"

if [[ -f AUTO_LOGIN_FILE ]]; then
    AUTO_LOGIN_MESSAGE=""
else
    COUNT_HASH=$(cat $AUTO_LOGIN_FILE | rg -c "#")
    AUTO_LOGIN_MESSAGE="(Autologin: $([[ $COUNT_HASH > 0 ]]  && echo "off"||echo "on"))"

fi

selection=$(echo -e $options | fzf --prompt="$AUTO_LOGIN_MESSAGE Select an action " --layout reverse --border )

case "$selection" in
    "Power off")
        systemctl poweroff
        ;;
    "Restart")
        systemctl reboot
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "Enable autologin")
        if [[ ! -f $AUTO_LOGIN_FILE ]]; then
            notify-send "No autologin file found, create it first" -u critical
            exit 0
        fi

        COUNT_HASH=$(cat $AUTO_LOGIN_FILE | rg -c "#")
        if [[ $COUNT_HASH -gt 0 ]]; then
            sudo sed -i "s/#//g" $AUTO_LOGIN_FILE
            sudo systemctl daemon-reload
            notify-send "Autologin enabled"
        else
            notify-send "Autologin already enabled"

        fi
        ;;
    "Disable autologin") if [[ ! -f $AUTO_LOGIN_FILE ]]; then
            notify-send "No autologin file found, create it first" -u critical
            exit 0
        fi

        COUNT_HASH=$(cat $AUTO_LOGIN_FILE | rg -c "#")
        if [[ $COUNT_HASH -eq 0 ]]; then
            sudo sed -i "s/ExecStart/#ExecStart/g" $AUTO_LOGIN_FILE
            sudo systemctl daemon-reload
            notify-send "Autologin disabled"
        else
            notify-send "Autologin already disabled"
        fi
        ;;
    *)
esac
