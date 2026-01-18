#!/bin/bash
if [ "$SETUP_PERSONAL" != true ]; then
    echo "${SKIPPING_PRE_TEXT} rclone-browser. SETUP_PERSONAL not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} rsync"
eval "sudo dnf install rclone-browser -y $OUTPUT_CONTROL"
