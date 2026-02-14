#!/bin/bash
# Terminate on any error
set -euo pipefail

# Clear Screen
clear

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR
# prepare logging directory
mkdir -p "$SCRIPT_DIR/logs"
LOG_FILE="$SCRIPT_DIR/logs/bootstrap_$(date +%Y%m%d_%H%M%S).log"
export LOG_FILE

# store user that is running the script
SCRIPT_USER="${SCRIPT_USER:-$(whoami)}"

# Source common utilities
source "${SCRIPT_DIR}/lib/common.sh"


main(){
    start_timer
    show_intro
    request_sudo_password

    fix_script_permissions

    source ./install/00-preflight.sh
    source ./install/20-install-software.sh
    source ./install/80-system-setup.sh
    source ./install/99-cleanup.sh

    load_configuration

    complete_package_installation
    complete_system_setup
    complete_cleanup
}

main

