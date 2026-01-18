#!/bin/bash
if [ "$SETUP_PERSONAL" != true ]; then
    echo "${SKIPPING_PRE_TEXT} discord. SETUP_PERSONAL is not true"
    return 0
fi


echo "${INSTALLING_PRE_TEXT} discord as Flatpak"
eval "flatpak install --system flathub com.discordapp.Discord -y $OUTPUT_CONTROL"
