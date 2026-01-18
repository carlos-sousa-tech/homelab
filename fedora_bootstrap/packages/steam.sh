#!/bin/bash
if [ "$SETUP_GAMING" != true ]; then
    echo "${SKIPPING_PRE_TEXT} bottles. SETUP_GAMING is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} bottles"
eval "sudo dnf install bottles -y $OUTPUT_CONTROL"
