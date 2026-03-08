#!/bin/bash
# Terminate on any error
set -euo pipefail

install_packages(){
    local -n packages_ref=$1  # Nameref to the array
    
    if [ ${#packages_ref[@]} -eq 0 ]; then
        error "Error: No packages provided"
        return 1
    fi

    log "Installing ${#packages_ref[@]} package(s)..."
    
    for package in "${packages_ref[@]}"; do
        log "Installing: $package"

        if [[ "$SETUP_DEBUG_MODE" = "true" ]]; then
            yay -S --needed --cleanafter --noconfirm "$package"
        fi

        if [[ "$SETUP_DEBUG_MODE" != "true" ]]; then
            yay -S --needed --cleanafter --noconfirm "$package" &> /dev/null
        fi

        if [ $? -eq 0 ]; then
            continue
        else
            log "✗ Failed to install $package"
            exit 1
        fi
    done
    log ""
}

complete_package_installation(){
    log_header "Installing PreFlight Packages"
    install_packages PACKAGES_INSTALL_PREFLIGHT

    log_header "Installing System Packages"
    install_packages PACKAGES_INSTALL_SYSTEM

    log_header "Installing GPU Packages"
    if [ "$SYSTEM_GPU_TYPE" = "nvidia" ]; then
        log_header "NVIDIA selected"
        install_packages PACKAGES_INSTALL_GPU_NVIDIA
    elif [ "$SYSTEM_GPU_TYPE" = "amd" ]; then
        log_header "AMD selected"
        install_packages PACKAGES_INSTALL_GPU_AMD
    else
        log_header "No Match (nvidia || amd)"
        log_header "No GPU Packages will be installed"
    fi

    log_header "Installing Media Packages"
    install_packages PACKAGES_INSTALL_UTILITIES

    log_header "Installing Media Packages"
    install_packages PACKAGES_INSTALL_MEDIA

    log_header "Installing Developer Packages"
    install_packages PACKAGES_INSTALL_DEVELOPER

    log_header "Installing Desktop Packages"
    install_packages PACKAGES_INSTALL_DESKTOP
}
