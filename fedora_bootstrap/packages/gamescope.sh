#!/bin/bash
if [ "$SETUP_GAMING" != true ]; then
    echo "${SKIPPING_PRE_TEXT} gamescope. SETUP_GAMING is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} gamescope"
eval "sudo dnf install gamescope -y $OUTPUT_CONTROL"
