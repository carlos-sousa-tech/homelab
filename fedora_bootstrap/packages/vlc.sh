#!/bin/bash
if [ "$SETUP_CORE_GUI" != true ]; then
    echo "${SKIPPING_PRE_TEXT} vlc. SETUP_CORE_GUI is not true"
    return 0
fi


echo "${INSTALLING_PRE_TEXT} vlc"
eval "sudo dnf install vlc -y $OUTPUT_CONTROL"
