#!/bin/bash
if [ "$SETUP_PERSONAL" != true ]; then
    echo "${SKIPPING_PRE_TEXT} darktable. SETUP_PERSONAL is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} darktable"
eval "sudo dnf install darktable -y $OUTPUT_CONTROL"
