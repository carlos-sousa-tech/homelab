#!/bin/bash
if [ "$SETUP_PERSONAL" != true ]; then
    echo "${SKIPPING_PRE_TEXT} inkscape. SETUP_PERSONAL is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} inkscape"
eval "sudo dnf install inkscape -y $OUTPUT_CONTROL"
