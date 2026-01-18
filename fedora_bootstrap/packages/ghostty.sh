#!/bin/bash
if [ "$SETUP_CORE_TTY" != true ]; then
    echo "${SKIPPING_PRE_TEXT} ghostty. SETUP_CORE_TTY is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} ghostty"
eval "dnf copr enable pgdev/ghostty -y $OUTPUT_CONTROL"
eval "dnf install ghostty -y $OUTPUT_CONTROL"
