#!/bin/bash
# Terminate on any error
set -euo pipefail


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
    inform_about_logs
    suggest_reboot
    elapsed_time
    #fix_log_permissions
}
