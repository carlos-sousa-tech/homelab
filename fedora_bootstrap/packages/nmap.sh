#!/bin/bash
if [ "$SETUP_WORKSTATION" != "true" ]; then
    echo "${SKIPPING_PRE_TEXT} nmap. SETUP_WORKSTATION is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} nmap"
eval "sudo dnf install nmap -y $OUTPUT_CONTROL"
