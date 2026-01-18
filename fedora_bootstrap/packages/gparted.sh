#!/bin/bash
if [ "$SETUP_CORE_GUI" != true ]; then
    echo "${SKIPPING_PRE_TEXT} gparted. SETUP_CORE_GUI is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} gparted"
eval "sudo dnf install gparted -y $OUTPUT_CONTROL"
