#!/bin/bash
# Terminate on any error
set -euo pipefail


enable_sddm(){
    log "Enabling sddm"
    sudo systemctl enable sddm
}


configure_docker(){
    log "Configuring docker daemon"
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": { "max-size": "10m", "max-file": "5" }
}
EOF

    
    log "Giving '$SCRIPT_USER' docker access"
    sudo usermod -aG docker ${SCRIPT_USER}

    log "Enabling Docker"
    sudo systemctl enable docker &> /dev/null
    sudo systemctl restart docker &> /dev/null
}


setup_locale(){
    log "Setting up locale for $SYSTEM_LOCALE"

     # Uncomment locale in /etc/locale.gen
    if grep -q "^#${SYSTEM_LOCALE}" /etc/locale.gen; then
        sudo sed -i "s/^#${SYSTEM_LOCALE}/${SYSTEM_LOCALE}/" /etc/locale.gen
    fi

    # Add if not found
    if ! grep -q "^${SYSTEM_LOCALE}" /etc/locale.gen; then
        sudo echo "${SYSTEM_LOCALE}" >> /etc/locale.gen
    fi

    log "Generating Locales"
    sudo locale-gen 1> /dev/null

    log "Setting default locale"
    sudo tee /etc/locale.conf >/dev/null <<EOF
LANG=${SYSTEM_LOCALE}
EOF
}


setup_keyboard(){
    log "Configuring X11 Keyboard Layout to '$SYSTEM_KEYBOARD_LAYOUT'"
    sudo localectl set-x11-keymap "$SYSTEM_KEYBOARD_LAYOUT" &> /dev/null
}



rebuild_initramfs(){
    log "Rebuilding initramfs"
    sudo mkinitcpio -P &> /dev/null
}


configure_hostname(){
    sudo hostnamectl set-hostname "$SYSTEM_HOSTNAME"
}


complete_system_setup(){
    log_header "Running System Setup Tasks"
    configure_docker
    setup_locale
    setup_keyboard
    configure_hostname
    rebuild_initramfs
    #enable_sddm
}
