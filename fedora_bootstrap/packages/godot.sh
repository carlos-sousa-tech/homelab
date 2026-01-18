#!/bin/bash
if [ "$SETUP_GAMEDEV" != true ]; then
    echo "${SKIPPING_PRE_TEXT} godot. SETUP_GAMEDEV is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} godot"
eval "sudo dnf install godot -y $OUTPUT_CONTROL"
