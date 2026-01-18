#!/bin/bash
#setup_fedora.sh
clear

# Exit immediately if a command exits with a non-zero status
set -e

# make sure we have sudo permissions
if [ "$EUID" -ne 0 ]; then
    echo "######"
    echo "This script must be run with sudo."
    echo "Attempting to rerun with sudo..."
    echo "######"
    echo ""

    # Re-run the script with sudo
    exec sudo "$0" "$@"

    # If we reach here, sudo failed to execute
    echo "Failed to access sudo. Exiting."
    exit 1
fi

# Change to script's directory (ensures correct path resolution)
cd "$(dirname "${BASH_SOURCE[0]}")" || exit

# Source settings.conf
. ./settings.conf

# Defines if we gonna be verbose or not
OUTPUT_CONTROL=""
if [ "$BE_VERBOSE" == false ]; then
    OUTPUT_CONTROL=">/dev/null 2>&1"
fi

# Source all utility scripts
echo "######"
echo ":: Sourcing Util Scripts"
echo "######"
for util_script in ./utils/*.sh; do
    source "$util_script"
done

start_stopwatch

echo "######"
echo ":: Sourcing Core Setup"
echo "######"
for repo_script in ./core/*.sh; do
    source "$repo_script"
done

echo "######"
echo ":: Sourcing Packages"
echo "######"
for pkg_script in ./packages/*.sh; do
    source "$pkg_script"
done


echo "######"
echo ":: Sourcing Cleanup"
echo "######"
for repo_script in ./cleanup/*.sh; do
    source "$repo_script"
done

stop_stopwatch
