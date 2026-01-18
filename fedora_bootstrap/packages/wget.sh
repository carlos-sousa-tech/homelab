#!/bin/bash
if [ "$SETUP_CORE_TTY" != true ]; then
    echo "${SKIPPING_PRE_TEXT} wget. SETUP_CORE_TTY is not true"
    return 0
fi


echo "${INSTALLING_PRE_TEXT} wget"
eval "sudo dnf install wget -y $OUTPUT_CONTROL"
