#!/bin/bash
if [ "$SETUP_CORE_TTY" != true ]; then
    echo "${SKIPPING_PRE_TEXT} duf. SETUP_CORE_TTY is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} duf"
eval "sudo dnf install duf -y $OUTPUT_CONTROL"
