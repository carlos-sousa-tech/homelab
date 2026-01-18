#!/bin/bash
echo "Adding Flathub"
eval "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo $OUTPUT_CONTROL"
