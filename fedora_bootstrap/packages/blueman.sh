#!/bin/bash
if [ "$SETUP_CORE_GUI" != true ]; then
    echo "${SKIPPING_PRE_TEXT} blueman. SETUP_CORE_GUI is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} blueman"
eval "sudo dnf install blueman -y $OUTPUT_CONTROL"
