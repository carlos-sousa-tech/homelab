#!/bin/bash
if [ "$SETUP_DEVELOPMENT" != true ]; then
    echo "${SKIPPING_PRE_TEXT} golang. SETUP_DEVELOPMENT is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} golang"
eval "sudo dnf install golang -y $OUTPUT_CONTROL"
