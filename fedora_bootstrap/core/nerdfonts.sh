#!/bin/bash
echo "Downloading Nerdfont"
eval "mkdir -p /tmp/nerdfont"
eval "wget -O /tmp/nerdfont/nerdfont.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip $OUTPUT_CONTROL"

echo "Unzipping NerdFonts"
eval "unzip -o /tmp/nerdfont/nerdfont.zip -d /tmp/nerdfont/ $OUTPUT_CONTROL"

echo "Installing NerdFonts"
eval "cp /tmp/nerdfont/*.otf /usr/share/fonts/ $OUTPUT_CONTROL"

echo "Removing temp data"
eval "rm -rf /tmp/nerdfont $OUTPUT_CONTROL"
