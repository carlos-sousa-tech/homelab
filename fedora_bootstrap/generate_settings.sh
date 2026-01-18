#!/bin/bash
# config_generator.sh

# Configuration file path
CONFIG_FILE="./settings.conf"
OPT_BE_VERBOSE=false
OPT_INSTALLING_PRE_TEXT=":: Installing - "
OPT_SKIPPING_PRE_TEXT="Skipping > "

# Function to prompt for yes/no questions with default as no
prompt_yes_no() {
    local prompt="$1"
    read -p "$prompt [y/N]: " response
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
    [[ "$response" == "y" || "$response" == "yes" ]]
}

# Function to prompt for free input
prompt_input() {
    local prompt="$1"
    local default="$2"
    read -p "$prompt ${default:+(current: $default)}: " response
    echo "${response:-$default}"
}

# Backup existing config file if it exists
if [ -f "$CONFIG_FILE" ]; then
    echo "Previous configuration file detected!"
    mv "$CONFIG_FILE" "${CONFIG_FILE}.backup"
    echo "Existing config file backed up."
fi

# Create new config file
touch "$CONFIG_FILE"

# System Questions
ANSWER_HOSTNAME=$(prompt_input "Enter device hostname:" "$HOSTNAME")
ANSWER_USERNAME=$(prompt_input "Enter target user" "$USER")

if prompt_yes_no "Do you want to setup Hyprland?"; then
    ANSWER_SETUP_HYPRLAND=true
else
    ANSWER_SETUP_HYPRLAND=false
fi


if prompt_yes_no "Are you using an NVIDIA GPU?"; then
    ANSWER_SETUP_NVIDIA=true
else
    ANSWER_SETUP_NVIDIA=false
fi


# Packages Questions
if prompt_yes_no "Do you want core TTY utilities? (probably yes)"; then
    ANSWER_SETUP_CORE_TTY=true
else
    ANSWER_SETUP_CORE_TTY=false
fi


if prompt_yes_no "Do you want core GUI utilities?"; then
    ANSWER_SETUP_CORE_GUI=true
else
    ANSWER_SETUP_CORE_GUI=false
fi

if prompt_yes_no "Do you work on this device?"; then
    ANSWER_SETUP_WORKSTATION=true
else
    ANSWER_SETUP_WORKSTATION=false
fi

if prompt_yes_no "Is this a personal device?"; then
    ANSWER_SETUP_PERSONAL=true
else
    ANSWER_SETUP_PERSONAL=false
fi


if prompt_yes_no "Do you play games on this device?"; then
    ANSWER_SETUP_GAMING=true
else
    ANSWER_SETUP_GAMING=false
fi


if prompt_yes_no "Do you develop (code) on this device?"; then
    ANSWER_SETUP_DEVELOPMENT=true
else
    ANSWER_SETUP_DEVELOPMENT=false
fi


if prompt_yes_no "Do you gamedev on this device?"; then
    ANSWER_SETUP_GAMEDEV=true
else
    ANSWER_SETUP_GAMEDEV=false
fi


if prompt_yes_no "Is this a VPS?"; then
    ANSWER_SETUP_VPS=true
else
    ANSWER_SETUP_VPS=false
fi




# Write configuration to file
cat > "$CONFIG_FILE" << EOF
# settings.conf
# Auto-Generated Configuration File
#####################
## System Settings
#####################

TARGET_HOSTNAME="$ANSWER_HOSTNAME"
MAIN_USER="$ANSWER_USERNAME"
SETUP_NVIDIA=$ANSWER_SETUP_NVIDIA
ANSWER_SETUP_HYPRLAND=$ANSWER_SETUP_HYPRLAND

## Core Utitilities - We probably want this in all systems
### btop, curl, duf, fastfetch, fzf, ghostty, git, ncdu, neovim, nmtui, rsync, timeshift, tmux, vim, wget, zsh, ohmyzsh
SETUP_CORE_TTY=$ANSWER_SETUP_CORE_TTY
### vlc, gparted, flameshot, pipewire
SETUP_CORE_GUI=$ANSWER_SETUP_CORE_GUI

## Work Systems - Do we work on this device?
### docker, docker-compose, LibreOffice, nmap, qemu-kvm, remmina, virt-manager, drawio
SETUP_WORKSTATION=$ANSWER_SETUP_WORKSTATION

## Personal Use - Do we use this device for personal things?
### Clementine, KeepassXC, LibreOffice, Syncthing, darktable, inkscape, gimp
SETUP_PERSONAL=$ANSWER_SETUP_PERSONAL

## Gaming Things - Are we Playing Games?
### steam, gamescope, bottles
SETUP_GAMING=$ANSWER_SETUP_GAMING

## Development - Do we develop on this machine?
### golang, nodejs, zed
SETUP_DEVELOPMENT=$ANSWER_SETUP_DEVELOPMENT

## GameDev - Do we develop GAMES on this machine?
### godot
SETUP_GAMEDEV=$ANSWER_SETUP_GAMEDEV

## VPS Utilities- Is it a VPS?
### docker, docker-compose
SETUP_VPS=$ANSWER_SETUP_VPS


#####################
## Script Settings
#####################
# true will give full command output | false will just display written echos
BE_VERBOSE=$OPT_BE_VERBOSE

INSTALLING_PRE_TEXT="$OPT_INSTALLING_PRE_TEXT"
SKIPPING_PRE_TEXT="$OPT_SKIPPING_PRE_TEXT"


EOF

echo "Configuration file created at $CONFIG_FILE"
