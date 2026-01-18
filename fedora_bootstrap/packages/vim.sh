#!/bin/bash
if [ "$SETUP_CORE_TTY" != true ]; then
    echo "${SKIPPING_PRE_TEXT} vim. SETUP_CORE_TTY is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} vim"
eval "sudo dnf install vim -y $OUTPUT_CONTROL"
