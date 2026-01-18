#!/bin/bash
if [ "$SETUP_CORE_TTY" != true ]; then
    echo "${SKIPPING_PRE_TEXT} neovim. SETUP_CORE_TTY is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} Neovim"
eval "sudo dnf install neovim -y $OUTPUT_CONTROL"
