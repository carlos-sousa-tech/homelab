#!/bin/bash
if [ "$SETUP_NVIDIA" != true ]; then
    echo "${SKIPPING_PRE_TEXT} nvidia. SETUP_NVIDIA is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} nvidia"
eval "sudo dnf install akmod-nvidia -y $OUTPUT_CONTROL"
echo "${INSTALLING_PRE_TEXT} nvidia-cuda and cuda-libs"
eval "sudo dnf install xorg-x11-drv-nvidia-cuda -y $OUTPUT_CONTROL"
eval "sudo dnf install xorg-x11-drv-nvidia-cuda-libs -y $OUTPUT_CONTROL"
