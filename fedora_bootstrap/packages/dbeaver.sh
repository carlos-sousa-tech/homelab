#!/bin/bash
if [ "$SETUP_DEVELOPMENT" != true ]; then
    echo "${SKIPPING_PRE_TEXT} dbeaver. SETUP_DEVELOPMENT is not true"
    return 0
fi


echo "${INSTALLING_PRE_TEXT} dbeaver as Flatpak"
eval "flatpak install --system flathub io.dbeaver.DBeaverCommunity -y $OUTPUT_CONTROL"
