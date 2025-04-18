#!/run/current-system/sw/bin/bash

# Lista os dispositivos Bluetooth disponíveis usando bluetoothctl
devices=$(bluetoothctl devices | awk '{print $3 " " $4}' | sed 's/://g')

# Se não houver dispositivos, avisa e sai
if [ -z "$devices" ]; then
    echo "Nenhum dispositivo Bluetooth encontrado."
    exit 1
fi

# Mostra os dispositivos em um menu wofi para o usuário escolher
selected_device=$(echo "$devices" | wofi --dmenu --prompt "Selecione o dispositivo Bluetooth:")

# Se o usuário não selecionar nada, sai
if [ -z "$selected_device" ]; then
    exit 1
fi

# Extrai o MAC address do dispositivo selecionado
device_mac=$(echo "$selected_device" | awk '{print $1}')

# Usa bluetoothctl para parear e conectar o dispositivo
echo -e "power on\nagent on\nscan on\npair $device_mac\nconnect $device_mac\nquit" | bluetoothctl

echo "Conectando ao dispositivo: $device_mac"
