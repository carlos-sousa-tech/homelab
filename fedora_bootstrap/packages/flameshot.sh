#!/bin/bash
if [ "$SETUP_CORE_GUI" != true ]; then
    echo "${SKIPPING_PRE_TEXT} flameshot. SETUP_CORE_GUI is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} flameshot"
eval "sudo dnf install flameshot -y $OUTPUT_CONTROL"
