#!/bin/bash
if [ "$SETUP_CORE_GUI" != true ]; then
    echo "${SKIPPING_PRE_TEXT} pipewire. SETUP_CORE_GUI is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} pipewire"
eval "sudo dnf install pipewire -y $OUTPUT_CONTROL"
