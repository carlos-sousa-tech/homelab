#!/bin/bash
if [ "$SETUP_WORKSTATION" != true ]; then
    echo "${SKIPPING_PRE_TEXT} audacity. SETUP_WORKSTATION is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} audacity"
eval "sudo dnf install audacity -y $OUTPUT_CONTROL"
