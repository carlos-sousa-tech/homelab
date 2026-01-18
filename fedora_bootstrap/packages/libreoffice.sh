#!/bin/bash

flag_install=false

if [ "$SETUP_PERSONAL" == "true" ]; then
    flag_install=true
fi
if [ "$SETUP_WORKSTATION" == "true" ]; then
    flag_install=true
fi

if [ "$flag_install" != true ]; then
    echo "${SKIPPING_PRE_TEXT} libreoffice. SETUP_PERSONAL and SETUP_WORKSTATION are both not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} libreoffice"
eval "sudo dnf install libreoffice -y $OUTPUT_CONTROL"
