#!/bin/bash
if [ "$SETUP_WORKSTATION" != true ]; then
    echo "${SKIPPING_PRE_TEXT} firefox. SETUP_WORKSTATION is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} firefox"
eval "sudo dnf install firefox -y $OUTPUT_CONTROL"
