st() {
    echo -e "   $(date +"%I:%M %p")  $(acpi | awk '{print $4, ($3 == "Charging," ? "🔌" : "🔋")}' | tr -d ',')  $(nmcli -t -f NAME connection show --active | head -n 1) (wifi)";
}
