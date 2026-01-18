#!/bin/bash
if [ "$SETUP_CORE_TTY" != true ]; then
    echo "${SKIPPING_PRE_TEXT} timeshift. SETUP_CORE_TTY is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} timeshift"
eval "sudo dnf install timeshift -y $OUTPUT_CONTROL"
