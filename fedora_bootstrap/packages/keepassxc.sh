#!/bin/bash
if [ "$SETUP_PERSONAL" != true ]; then
    echo "${SKIPPING_PRE_TEXT} keepassxc. SETUP_PERSONAL is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} KeePassXC"
eval "sudo dnf install keepassxc -y $OUTPUT_CONTROL"
