#!/run/current-system/sw/bin/bash

set -euo pipefail

INTERFACE=$(nmcli device | awk '$2=="wifi" {print $1}')

networks=$(nmcli -t -f SSID,SIGNAL device wifi list ifname "$INTERFACE" \
  | grep -v '^--' \
  | awk -F: '!seen[$1]++ {printf "%s [%s%%]\n", $1, $2}')

chosen=$(echo "$networks" | wofi --dmenu --prompt "Wi-Fi")

[ -z "$chosen" ] && exit 0

ssid=$(echo "$chosen" | sed 's/ *\[[0-9]\+%\]//')

# Tenta conectar diretamente
if ! nmcli device wifi connect "$ssid" ifname "$INTERFACE"; then
  pass=$(wofi --dmenu --password --prompt "Senha para '$ssid'")
  nmcli device wifi connect "$ssid" password "$pass" ifname "$INTERFACE"
fi
