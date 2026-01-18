#!/bin/bash
if [ "$SETUP_WORKSTATION" != true ]; then
    echo "${SKIPPING_PRE_TEXT} drawio. SETUP_WORKSTATION is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} drawio as Flatpak"
eval "flatpak install --system flathub com.jgraph.drawio.desktop -y $OUTPUT_CONTROL"
