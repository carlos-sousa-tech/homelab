#!/bin/bash
if [ "$SETUP_WORKSTATION" != true ]; then
    echo "${SKIPPING_PRE_TEXT} brave-browser. SETUP_WORKSTATION is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} brave-browser"
eval "sudo dnf install dnf-plugins-core -y $OUTPUT_CONTROL"
eval "sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo --overwrite -y $OUTPUT_CONTROL"
eval "sudo dnf install brave-browser -y $OUTPUT_CONTROL"
