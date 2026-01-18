#!/bin/bash
if [ "$SETUP_WORKSTATION" != "true" ]; then
    echo "${SKIPPING_PRE_TEXT} remmina. SETUP_WORKSTATION is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} remmina"
eval "sudo dnf install remmina -y $OUTPUT_CONTROL"
