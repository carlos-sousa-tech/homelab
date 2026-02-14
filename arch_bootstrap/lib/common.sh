#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


# Logging functions
log() {
    local message="${BLUE}[$(date +%H:%M:%S)]${NC} $*"
    echo -e "$message"
    echo -e "[$(date +%H:%M:%S)] $*" >> "$LOG_FILE"
}

log_header() {
    local message="${BLUE}[$(date +%H:%M:%S)]${NC} $*"
    log ""
    log "=============="
    echo -e "$message"
    echo -e "[$(date +%H:%M:%S)] $*" >> "$LOG_FILE"
    log "=============="
    log ""
}

success() {
    local message="${GREEN}[SUCCESS]${NC} $*"
    echo -e "$message"
    echo -e "[SUCCESS] $*" >> "$LOG_FILE"
}

warn() {
    local message="${YELLOW}[WARNING]${NC} $*"
    echo -e "$message"
    echo -e "[WARNING] $*" >> "$LOG_FILE"
}

error() {
    local message="${RED}[ERROR]${NC} $*"
    echo -e "$message" >&2
    echo -e "[ERROR] $*" >> "$LOG_FILE"
}

# Package installation helper
install_pkg() {
    local pkgs=("$@")
    log "Installing: ${pkgs[*]}"
    pacman -S --needed --noconfirm "${pkgs[@]}" || {
        error "Failed to install packages: ${pkgs[*]}"
            return 1
        }
}


request_sudo_password(){
    log "You need sudo permissions for some tasks"
    log "Please provide your password:"
    sudo -v
}


check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (use: sudo ${0})"
        exit 1
    fi
}


fix_script_permissions(){
    log "Set +x on ./install/*"
    chmod +x install/*
}


show_intro(){
    log ""
    log "============================"
    log "Arch Linux Bootstrapper v1.0"
    log "============================"
    log ""
}


start_timer() {
    TIMER_START=$(date +%s)
    log "Timer started at $(date)"
}

# Function 2: Check elapsed time and convert to human-readable format
elapsed_time() {
    if [ -z "$TIMER_START" ]; then
        log "Error: Timer not started. Call start_timer first."
        return 1
    fi
    
    local current_time=$(date +%s)
    local elapsed=$((current_time - TIMER_START))
    
    local hours=$((elapsed / 3600))
    local minutes=$(((elapsed % 3600) / 60))
    local seconds=$((elapsed % 60))
    
    # Pad hours and minutes with leading zeros
    hours=$([ $hours -lt 10 ] && echo "0$hours" || echo "$hours")
    minutes=$([ $minutes -lt 10 ] && echo "0$minutes" || echo "$minutes")
    
    log "Elapsed time: $hours:$minutes:$seconds"
}



load_configuration(){
    CONFIG_FILE="configs/config.json"
    log "Loading Configuration: $CONFIG_FILE"
    # properly map the array as array
    mapfile -t PACKAGES_INSTALL_PREFLIGHT < <(jq -r '.packages.install.preflight[]' "$CONFIG_FILE")
    mapfile -t PACKAGES_INSTALL_SYSTEM < <(jq -r '.packages.install.system[]' "$CONFIG_FILE")
    mapfile -t PACKAGES_INSTALL_DESKTOP < <(jq -r '.packages.install.desktop[]' "$CONFIG_FILE")
    mapfile -t PACKAGES_INSTALL_DEVELOPER < <(jq -r '.packages.install.developer[]' "$CONFIG_FILE")
    mapfile -t PACKAGES_INSTALL_MEDIA < <(jq -r '.packages.install.media[]' "$CONFIG_FILE")
    mapfile -t PACKAGES_INSTALL_UTILITIES < <(jq -r '.packages.install.utilities[]' "$CONFIG_FILE")
    mapfile -t PACKAGES_INSTALL_GPU < <(jq -r '.packages.install.gpu[]' "$CONFIG_FILE")

    SETUP_DEBUG_MODE=$(jq -r '.setup.debug_mode' "$CONFIG_FILE")

    SYSTEM_LOCALE=$(jq -r '.system.locale' "$CONFIG_FILE")
    SYSTEM_KEYBOARD_LAYOUT=$(jq -r '.system.keyboard_layout' "$CONFIG_FILE")
    SYSTEM_HOSTNAME=$(jq -r '.system.hostname' "$CONFIG_FILE")

    log ""
}
