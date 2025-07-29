#!/bin/bash

# ===== Device info: [ID]="MAC|Category|Display Name" =====
declare -A DEVICES=(
  [hp]="88:C9:E8:78:3B:4B|audio|WH-1000XM5"
  [gh]="D8:6C:63:4D:B2:2A|audio|GoogleHome"
  [ep]="F4:9D:8A:01:6D:CE|audio|soundcore Liberty 4 NC"
  [mc]="D7:D2:DE:B5:12:DE|input|MX Master 3S"
  [kb]="C4:C1:63:09:AA:4A|input|HHKB-Hybrid_1"
)

# ===== Select action =====
action=$(printf "connect\ndisconnect\nprofile" | rofi -dmenu -p "Action:")
[[ -z "$action" ]] && exit 0

if [[ "$action" == "profile" ]]; then
  # === Find currently connected audio device ===
  connected_device=""
  for key in "${!DEVICES[@]}"; do
    IFS='|' read -r mac category name <<< "${DEVICES[$key]}"
    if [[ "$category" == "audio" ]]; then
      if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        connected_device="$mac"
        break
      fi
    fi
  done

  if [[ -z "$connected_device" ]]; then
    notify-send "No connected audio device found"
    exit 1
  fi

  # === Get the card name from pactl ===
  card=$(pactl list cards short | grep "${connected_device//:/_}" | awk '{print $2}')
  if [[ -z "$card" ]]; then
    notify-send "No matching PulseAudio card for $connected_device"
    exit 1
  fi

  # === Choose profile ===
  profile=$(printf "a2dp-sink (高音質音声専用)\nheadset-head-unit-msbc (マイク対応)" | rofi -dmenu -p "Select profile:")
  [[ -z "$profile" ]] && exit 0

  # === Map to actual profile name ===
  if [[ "$profile" == *a2dp-sink* ]]; then
    profile_name="a2dp-sink"
  elif [[ "$profile" == *msbc* ]]; then
    profile_name="headset-head-unit-msbc"
  else
    notify-send "Unknown profile selected"
    exit 1
  fi

  # === Apply profile ===
  pactl set-card-profile "$card" "$profile_name"
  notify-send "Bluetooth profile set to: $profile_name"
  exit 0
fi

# ===== Show device options =====
device_options=()
for key in "${!DEVICES[@]}"; do
  IFS='|' read -r _ _ name <<< "${DEVICES[$key]}"
  device_options+=("$key $name")
done

choice=$(printf "%s\n" "${device_options[@]}" | rofi -dmenu -p "$action device:")
[[ -z "$choice" ]] && exit 0

device_id="${choice%% *}"
device_info="${DEVICES[$device_id]}"
IFS='|' read -r TARGET_MAC CATEGORY DEVICE_NAME <<< "$device_info"

# ===== Perform connect/disconnect =====
if [[ "$action" == "connect" ]]; then
  for key in "${!DEVICES[@]}"; do
    IFS='|' read -r mac cat _ <<< "${DEVICES[$key]}"
    [[ "$cat" == "$CATEGORY" && "$mac" != "$TARGET_MAC" ]] && bluetoothctl disconnect "$mac" >/dev/null
  done
  bluetoothctl connect "$TARGET_MAC"
else
  bluetoothctl disconnect "$TARGET_MAC"
fi
