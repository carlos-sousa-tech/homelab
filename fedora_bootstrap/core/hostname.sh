#!/bin/bash
if [ -n "TARGET_HOSTNAME" ]; then
    # Set the hostname
    sudo hostnamectl set-hostname "$TARGET_HOSTNAME"
    echo "Hostname set to: $TARGET_HOSTNAME"
else
    echo "TARGET_HOSTNAME variable is not set. Skipping hostname change."
fi
