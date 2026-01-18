#!/bin/bash

if [ "$SETUP_PERSONAL" != true ]; then
    echo "${SKIPPING_PRE_TEXT} syncthing. SETUP_PERSONAL is not true"
    return 0
fi

if [ -z "$MAIN_USER" ]; then
    echo "${SKIPPING_PRE_TEXT} syncthing. MAIN_USER is not set"
    return 0
fi


echo "${INSTALLING_PRE_TEXT} syncthing"
eval "sudo dnf install syncthing -y $OUTPUT_CONTROL"

# Define variables
SERVICE_NAME="syncthing"
SERVICE_DESCRIPTION="Syncthing - Open Source Continuous File Synchronization"
EXECUTABLE_PATH="/usr/bin/syncthing serve --no-browser --logfile=default"
SERVICE_FILE="/etc/systemd/system/syncthing.service"

cat << EOF > ${SERVICE_FILE}
[Unit]
Description=${SERVICE_DESCRIPTION}

[Service]
User=${MAIN_USER}
ExecStart=${EXECUTABLE_PATH}
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# Reload systemd to recognize the new service
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable ${SERVICE_NAME}
systemctl start ${SERVICE_NAME}
