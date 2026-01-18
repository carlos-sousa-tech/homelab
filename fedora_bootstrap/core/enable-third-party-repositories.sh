#!/bin/bash
echo "Adding rpmfusion free"
eval "sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y $OUTPUT_CONTROL"
echo "Adding rpmfusion non-free"
eval "sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y $OUTPUT_CONTROL"

