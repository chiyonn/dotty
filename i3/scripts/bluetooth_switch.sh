#!/bin/bash

# ===== Device info: [ID]="MAC|Category|Display Name" =====
declare -A DEVICES=(
  [hp]="88:C9:E8:78:3B:4B|audio|WH-1000XM5"
  [gh]="D8:6C:63:4D:B2:2A|audio|GoogleHome"
  [ep]="F4:9D:8A:01:6D:CE|audio|soundcore Liberty 4 NC"
  [mc]="D7:D2:DE:B5:12:DE|input|MX Master 3S"
  [kb]="C4:C1:63:09:AA:4A|input|HHKB-Hybrid_1"
)

# ===== rofi wrapper =====
rofi_dmenu() {
  rofi -dmenu -i -p "$1"
}

# ===== Select action =====
action=$(printf "connect\ndisconnect" | rofi_dmenu "Action:")
[[ -z "$action" ]] && exit 0

# ===== Select device =====
device_options=()
for key in "${!DEVICES[@]}"; do
  IFS='|' read -r _ _ name <<< "${DEVICES[$key]}"
  device_options+=("$key $name")
done

choice=$(printf "%s\n" "${device_options[@]}" | rofi_dmenu "$action device:")
[[ -z "$choice" ]] && exit 0

device_id="${choice%% *}"
device_info="${DEVICES[$device_id]}"
IFS='|' read -r TARGET_MAC CATEGORY DEVICE_NAME <<< "$device_info"

# ===== Connect logic =====
if [[ "$action" == "connect" ]]; then
  # Disconnect others in same category
  for key in "${!DEVICES[@]}"; do
    IFS='|' read -r mac cat _ <<< "${DEVICES[$key]}"
    [[ "$cat" == "$CATEGORY" && "$mac" != "$TARGET_MAC" ]] && bluetoothctl disconnect "$mac" >/dev/null
  done

  bluetoothctl connect "$TARGET_MAC"

  # Wait briefly for connection to stabilize
  sleep 2

  # Detect card name (bluez_card.XX_XX_XX_XX_XX_XX)
  CARD=$(pactl list cards short | grep "$TARGET_MAC" | awk '{print $2}')
  if [[ -n "$CARD" ]]; then
    profile=$(printf "a2dp-sink\nheadset-head-unit-msbc" | rofi_dmenu "Profile for $DEVICE_NAME:")
    [[ -n "$profile" ]] && pactl set-card-profile "$CARD" "$profile"
  fi

else
  bluetoothctl disconnect "$TARGET_MAC"
fi
