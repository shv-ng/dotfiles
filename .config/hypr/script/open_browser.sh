#!/bin/bash

current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

if [ "$current_ws" -eq 2 ]; then
    if ! pgrep -f "firefox-developer-edition" > /dev/null; then
        nohup firefox-developer-edition > /dev/null 2>&1 &
        sleep 0.2
        exit 0
    fi
fi

website=$(echo -e 'Normal\nWhatsapp\nYouTube\nLinkedIn\nChatGPT\nGitHub\nYoutube Music\nGMail\nGoogle Docs\nGoogle Sheets\nTelegram' | fzf --layout reverse --border )

case "$website" in
    "Whatsapp") url="https://web.whatsapp.com" ;;
    "YouTube") url="https://youtube.com" ;;
    "LinkedIn") url="https://linkedin.com" ;;
    "ChatGPT") url="https://chatgpt.com" ;;
    "GitHub") url="https://github.com/ShivangSrivastava" ;;
    "Youtube Music") url="https://music.youtube.com" ;;
    "GMail") url="https://mail.google.com" ;;
    "Google Docs") url="https://docs.google.com/document/u/0/" ;;
    "Google Sheets") url="https://docs.google.com/spreadsheets/u/0/" ;;
    "Telegram") url="https://web.telegram.org/a/" ;;
    *) url="about:home" ;;
esac

if  pgrep -f "firefox-developer-edition" > /dev/null; then
    xdg-open "$url"
else
    if [ -z "$url" ]; then
        hyprctl dispatch workspace 2
        nohup firefox-developer-edition >/dev/null 2>&1 &
    else
        hyprctl dispatch workspace 2
        nohup firefox-developer-edition "$url" >/dev/null 2>&1 &

    fi
    sleep 0.2
fi
