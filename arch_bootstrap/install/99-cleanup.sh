#!/bin/bash
# Terminate on any error
set -euo pipefail

remove_packages(){
    local -n packages_ref=$1  # Nameref to the array

    log_header "Removing Packages marked to be absent"
    
    if [ ${#packages_ref[@]} -eq 0 ]; then
        error "Error: No packages provided"
        return 1
    fi

    log "Removing ${#packages_ref[@]} package(s)..."
    
    for package in "${packages_ref[@]}"; do
        if ! pacman -Q "$package" &> /dev/null; then
            log "Package $package not installed. Skipping..."
            continue
        fi

        log "Removing: $package"

        if [[ "$SETUP_DEBUG_MODE" = "true" ]]; then
            yay -Rs --noconfirm "$package"
        fi

        if [[ "$SETUP_DEBUG_MODE" != "true" ]]; then
            yay -Rs --noconfirm "$package" &> /dev/null
        fi

        if [ $? -eq 0 ]; then
            continue
        else
            log "✗ Failed to remove $package"
            exit 1
        fi
    done
    log ""
}

cleanup_packages(){
    log_header "Cleaning Packages"
    log "Removing Unused Dependencies"
    yay -Yc --noconfirm &> /dev/null

    log "Removing Package Caches"
    yay -Sc --noconfirm &> /dev/null
}

suggest_reboot(){
    log_header "Completed"
    log "It's **highly** recommended to reboot the system"
    log ""
}

inform_about_logs(){
    log "You can find the log of this run here:"
    log "$LOG_FILE"
}

fix_log_permissions(){
    log "Fixing Log Permissions: $SCRIPT_DIR/logs"
    chown -R "$SCRIPT_USER:$SCRIPT_USER" "$SCRIPT_DIR/logs"
}


complete_cleanup(){
    log_header "Running CleanUp Tasks"
    remove_packages PACKAGES_ABSENT
    cleanup_packages
    inform_about_logs
    suggest_reboot
    elapsed_time
    #fix_log_permissions
}
