#!/bin/bash

flag_install=false

if [ "$SETUP_WORKSTATION" == "true" ]; then
    flag_install=true
fi
if [ "$SETUP_VPS" == "true" ]; then
    flag_install=true
fi

if [ "$flag_install" != true ]; then
    echo "${SKIPPING_PRE_TEXT} docker. SETUP_WORKSTATION and SETUP_VPS are both not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} docker, docker-compose"
eval "sudo dnf install docker docker-compose -y $OUTPUT_CONTROL"




if [ -z "$MAIN_USER" ]; then
    echo "MAIN_USER is not set. Skipping adding user to docker group"
else
    echo "Adding ${MAIN_USER} to docker group"
    eval "sudo usermod -aG docker $MAIN_USER"
fi

if [ "$SETUP_NVIDIA" != true ]; then
    echo "${SKIPPING_PRE_TEXT} nvidia container toolkit. SETUP_NVIDIA is not true"
else
    echo "Adding nvidia-container-toolkit repo"
    eval "curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo"

    echo "${INSTALLING_PRE_TEXT} nvidia-container-tookit"
    eval "sudo dnf install -y nvidia-container-toolkit -y $OUTPUT_CONTROL"
    eval "sudo nvidia-ctk runtime configure --runtime=docker"
    eval "sudo systemctl restart docker"
fi
