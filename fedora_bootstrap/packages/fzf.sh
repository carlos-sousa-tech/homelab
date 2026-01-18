#!/bin/bash
if [ "$SETUP_CORE_TTY" != true ]; then
    echo "${SKIPPING_PRE_TEXT} fzf. SETUP_CORE_TTY is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} fzf"
eval "sudo dnf install fzf -y $OUTPUT_CONTROL"
