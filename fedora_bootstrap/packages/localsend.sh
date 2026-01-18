#!/bin/bash
if [ "$SETUP_WORKSTATION" != true ]; then
    echo "${SKIPPING_PRE_TEXT} localsend. SETUP_WORKSTATION is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} localsend as Flatpak"
eval "flatpak install --system flathub org.localsend.localsend_app -y $OUTPUT_CONTROL"
