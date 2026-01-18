#!/bin/bash
if [ "$SETUP_CORE_TTY" != true ]; then
    echo "${SKIPPING_PRE_TEXT} fastfetch. SETUP_CORE_TTY is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} fastfetch"
eval "sudo dnf install fastfetch -y $OUTPUT_CONTROL"
