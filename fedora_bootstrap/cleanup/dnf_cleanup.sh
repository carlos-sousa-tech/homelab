#!/bin/bash
echo "Checking Updates and Updating"
eval "sudo dnf check-update -y $OUTPUT_CONTROL"
eval "sudo dnf update -y $OUTPUT_CONTROL"

echo "Running Autoremove"
eval "sudo dnf autoremove -y $OUTPUT_CONTROL"


echo "Updating Flatpaks"
eval "sudo flatpak update -y $OUTPUT_CONTROL"
