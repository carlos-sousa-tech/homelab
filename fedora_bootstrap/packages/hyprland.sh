#!/bin/bash
if [ "$SETUP_WM_HYPRLAND" != true ]; then
    echo "${SKIPPING_PRE_TEXT} hyprland. SETUP_WM_HYPRLAND is not true"
    return 0
fi
echo "${INSTALLING_PRE_TEXT} hyperland"
eval "sudo dnf copr enable solopasha/hyprland -y $OUTPUT_CONTROL"
eval "sudo dnf install ark dolphin hyprland hyprlock hyprpaper hyprpolkitagent pavucontrol wdisplays -y $OUTPUT_CONTROL"
echo "${INSTALLING_PRE_TEXT} hyprland helpers: rofi, waybar, dunst, etc"
eval "sudo dnf install dunst rofi waybar -y $OUTPUT_CONTROL"
