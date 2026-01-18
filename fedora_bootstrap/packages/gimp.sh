#!/bin/bash
if [ "$SETUP_PERSONAL" != true ]; then
    echo "${SKIPPING_PRE_TEXT} gimp. SETUP_PERSONAL is not true"
    return 0
fi


echo "${INSTALLING_PRE_TEXT} gimp gmic-qt as Flatpak"
eval "flatpak install --system flathub org.gimp.GIMP -y $OUTPUT_CONTROL"
eval "flatpak install --system flathub org.gimp.GIMP.Plugin.GMic//3 -y $OUTPUT_CONTROL"
