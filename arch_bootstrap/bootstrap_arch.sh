#!/bin/bash

# Terminate on any error
set -euo pipefail

# Clear Screen
clear

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
error_exit() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

ask() {
    read -p "$1" response
    echo "$response"
}

# Check prerequisites
if [ "$EUID" -ne 0 ]; then
    error_exit "Please run as root (sudo)"
fi


## Install Display Servers
#sudo pacman -Sy --noconfirm xorg-server wayland
#
## Install Plasma (KDE)
#sudo pacman -Sy --noconfirm plasma-desktop plasma-wayland-protocols
#
## Improve Plasma Experience
#sudo pacman -Sy --noconfirm kde-applications
#
## Install Hyprland
#sudo pacman -Sy --noconfirm hyprland hyprland-protocols
#
## Install Display Manager
#sudo pacman -Sy --noconfirm sddm sddm-kcm
#sudo systemctl enable sddm
#
#
#
## Install Tools
##sudo pacman -Sy --noconfirm dolphin konsole
##sudo pacman -Sy --noconfirm kitty
#sudo pacman -Sy --noconfirm git
#sudo pacman -Sy --noconfirm neovim
#
#
## Configure X11 Keyboard Layout
#sudo locaectl set-x11-keymap de


sudo chmod +x install/*.sh

# Directory containing installation scripts
INSTALL_DIR="./install"

# Check if install directory exists
if [[ ! -d "$INSTALL_DIR" ]]; then
    error_exit "Error: $INSTALL_DIR directory not found"
fi

# Find and execute all .sh files in order
scripts=($(find "$INSTALL_DIR" -maxdepth 1 -name "*.sh" -type f | sort))

if [[ ${#scripts[@]} -eq 0 ]]; then
    error_exit "No scripts found in $INSTALL_DIR"
fi

info "Found ${#scripts[@]} installation script(s)"


# Source and execute each script
for script in "${scripts[@]}"; do
    script_name=$(basename "$script")
    info "▶ Executing: $script_name"
    
    if source "$script"; then
        info "✓ Completed: $script_name$"
    else
        error_exit "✗ Failed: $script_name"
    fi
done

info "All installation scripts completed successfully!"
