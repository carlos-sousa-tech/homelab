#!/bin/bash
if [ "$SETUP_PERSONAL" != true ]; then
    echo "${SKIPPING_PRE_TEXT} clementine. SETUP_PERSONAL is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} clementine"
eval "sudo dnf install clementine -y $OUTPUT_CONTROL"
