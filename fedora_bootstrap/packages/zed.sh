#!/bin/bash
if [ "$SETUP_DEVELOPMENT" != true ]; then
    echo "${SKIPPING_PRE_TEXT} zed. SETUP_DEVELOPMENT is not true"
    return 0
fi


echo "${INSTALLING_PRE_TEXT} zed as Flatpak"
eval "flatpak install --system flathub dev.zed.Zed -y $OUTPUT_CONTROL"
