#!/bin/bash
# Terminate on any error
set -euo pipefail


log_header "Starting PreFlight Setup"
# Make sure essential packages are present 
log "Updating packages database"
sudo pacman -Sy --noconfirm &> /dev/null;
log ""
log "Installing required packages"
log "- jq"
sudo pacman -S jq --noconfirm &> /dev/null;
log "- git"
sudo pacman -S git --noconfirm &> /dev/null;
log "- base-devel"
sudo pacman -S base-devel --noconfirm &> /dev/null;

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    log "yay not found. Installing..."
    
    # Clone and build yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi


log "Updating yay database"
yay -Sy --noconfirm  &> /dev/null;

log ""
