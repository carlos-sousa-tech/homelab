#!/bin/bash
if [ "$SETUP_WORKSTATION" != "true" ]; then
    echo "${SKIPPING_PRE_TEXT} qemu-kvm. SETUP_WORKSTATION is not true"
    return 0
fi

echo "${INSTALLING_PRE_TEXT} qemu-kvm virt-manager bridge-utils libvirt virt-viewer"
eval "sudo dnf install qemu-kvm virt-manager libvirt bridge-utils virt-viewer -y $OUTPUT_CONTROL"


if [ -z "$MAIN_USER" ]; then
    "MAIN_USER is not set. Skipping adding user to libvirt"
else
    echo "Adding ${MAIN_USER} to libvirt"
    eval "sudo usermod -aG libvirt $MAIN_USER"
fi

