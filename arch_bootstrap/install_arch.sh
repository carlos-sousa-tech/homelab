#!/bin/bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
error_exit() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

ask() {
    read -p "$1" response
    echo "$response"
}

# Check prerequisites
if [ "$EUID" -ne 0 ]; then
    error_exit "Please run as root (sudo)"
fi

if [ ! -d /sys/firmware/efi/efivars ]; then
    error_exit "Not booted in UEFI mode. This script requires UEFI boot."
fi

clear
echo -e "${BLUE}=== Arch Linux Automated Installer ===${NC}"
echo ""

# --- Prompt for Variables ---

# Keyboard
KEYMAP=$(ask "Enter keyboard layout [de-latin1]: ")
KEYMAP=${KEYMAP:-de-latin1}

# Disk selection
echo ""
echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL,TYPE | grep -E "disk" || true
echo ""
DISK=$(ask "Enter target disk (e.g., sda, nvme0n1): ")
DISK_PATH="/dev/$DISK"

if [ ! -b "$DISK_PATH" ]; then
    error_exit "Disk $DISK_PATH does not exist!"
fi

if mount | grep -q "$DISK_PATH"; then
    error_exit "Disk $DISK_PATH is currently mounted. Please unmount first."
fi

# Determine partition naming (nvme0n1p1 vs sda1)
if [[ "$DISK" =~ ^nvme ]]; then
    EFI_PART="${DISK_PATH}p1"
    SWAP_PART="${DISK_PATH}p2"
    ROOT_PART="${DISK_PATH}p3"
else
    EFI_PART="${DISK_PATH}1"
    SWAP_PART="${DISK_PATH}2"
    ROOT_PART="${DISK_PATH}3"
fi

# Sizes
EFI_SIZE=$(ask "Enter EFI partition size in GB [1]: ")
EFI_SIZE=${EFI_SIZE:-1}
SWAP_SIZE=$(ask "Enter swap size in GB [4]: ")
SWAP_SIZE=${SWAP_SIZE:-4}

# Timezone
TIMEZONE=$(ask "Enter timezone [Europe/Berlin]: ")
TIMEZONE=${TIMEZONE:-Europe/Berlin}
if [ ! -f "/usr/share/zoneinfo/$TIMEZONE" ]; then
    error_exit "Invalid timezone: $TIMEZONE"
fi

# Locale
LOCALE=$(ask "Enter locale [en_US.UTF-8]: ")
LOCALE=${LOCALE:-en_US.UTF-8}

# Hostname
HOSTNAME=$(ask "Enter hostname: ")
[ -z "$HOSTNAME" ] && error_exit "Hostname cannot be empty"

# Root password
while true; do
    read -s -p "Enter root password: " ROOT_PASSWORD
    echo ""
    read -s -p "Confirm root password: " ROOT_PASSWORD_CONFIRM
    echo ""
    if [ "$ROOT_PASSWORD" = "$ROOT_PASSWORD_CONFIRM" ]; then
        break
    else
        warning "Passwords do not match. Try again."
    fi
done

# CPU Microcode
echo ""
echo "Select CPU vendor:"
echo "1) AMD (amd-ucode)"
echo "2) Intel (intel-ucode)"
CPU_CHOICE=$(ask "Choice [1]: ")
CPU_CHOICE=${CPU_CHOICE:-1}
if [ "$CPU_CHOICE" == "2" ]; then
    UCODE_PKG="intel-ucode"
else
    UCODE_PKG="amd-ucode"
fi

# Additional options
echo ""
INSTALL_SSH=$(ask "Install and enable SSH server? [y/N]: ")
INSTALL_SSH=${INSTALL_SSH:-n}

CREATE_USER=$(ask "Create regular user? [y/N]: ")
CREATE_USER=${CREATE_USER:-n}

if [[ "$CREATE_USER" =~ ^[Yy]$ ]]; then
    USERNAME=$(ask "Enter username: ")
    [ -z "$USERNAME" ] && error_exit "Username cannot be empty"
    read -s -p "Enter password for $USERNAME: " USER_PASSWORD
    echo ""
fi

# Final confirmation
echo ""
warning "This will DESTROY ALL DATA on $DISK_PATH"
warning "Partitions to be created:"
echo "  - $EFI_PART : EFI System (${EFI_SIZE}G)"
echo "  - $SWAP_PART : Linux Swap (${SWAP_SIZE}G)"
echo "  - $ROOT_PART : Linux Filesystem (remainder)"
echo ""
CONFIRM=$(ask "Type 'yes' to proceed: ")
if [ "$CONFIRM" != "yes" ]; then
    info "Installation aborted."
    exit 0
fi

# --- Installation ---

info "Setting keyboard layout..."
loadkeys "$KEYMAP"

info "Updating system clock..."
timedatectl set-ntp true

# Partitioning with sgdisk (scriptable GPT)
info "Partitioning $DISK_PATH..."
if ! command -v sgdisk &> /dev/null; then
    pacman -Sy --noconfirm gptfdisk
fi

sgdisk -Z "$DISK_PATH" 2>/dev/null || true
sgdisk -n 1:0:+${EFI_SIZE}G -t 1:ef00 -c 1:"EFI System" "$DISK_PATH"
sgdisk -n 2:0:+${SWAP_SIZE}G -t 2:8200 -c 2:"Linux swap" "$DISK_PATH"
sgdisk -n 3:0:0 -t 3:8300 -c 3:"Linux root" "$DISK_PATH"

info "Formatting partitions..."
mkfs.fat -F 32 "$EFI_PART"
mkswap "$SWAP_PART"
mkfs.ext4 "$ROOT_PART"

info "Mounting partitions..."
mount "$ROOT_PART" /mnt
swapon "$SWAP_PART"
mount --mkdir "$EFI_PART" /mnt/boot

# Determine packages
PACKAGES="base linux linux-firmware nano vim man-db man-pages networkmanager grub efibootmgr $UCODE_PKG"
if [[ "$INSTALL_SSH" =~ ^[Yy]$ ]]; then
    PACKAGES="$PACKAGES openssh"
fi
if [[ "$CREATE_USER" =~ ^[Yy]$ ]]; then
    PACKAGES="$PACKAGES sudo"
fi

info "Installing base system (this may take a while)..."
pacstrap /mnt $PACKAGES

info "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Prepare chroot configuration
info "Configuring system..."

# Create config file for chroot
cat > /mnt/chroot_vars << EOF
TIMEZONE=$TIMEZONE
LOCALE=$LOCALE
KEYMAP=$KEYMAP
HOSTNAME=$HOSTNAME
UCODE_PKG=$UCODE_PKG
INSTALL_SSH=$INSTALL_SSH
CREATE_USER=$CREATE_USER
USERNAME=$USERNAME
EOF

# Save passwords securely (will be deleted after use)
echo "$ROOT_PASSWORD" > /mnt/root_pass
if [[ "$CREATE_USER" =~ ^[Yy]$ ]]; then
    echo "$USER_PASSWORD" > /mnt/user_pass
fi

# Create chroot script
cat > /mnt/chroot_setup.sh << 'CHROOT_SCRIPT'
#!/bin/bash
set -e
source /chroot_vars

# Time
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Locale
echo "$LOCALE UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

# Console keyboard
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

# Hostname
echo "$HOSTNAME" > /etc/hostname
cat >> /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain   $HOSTNAME
EOF

# Root password
echo "root:$(cat /root_pass)" | chpasswd

# Network
systemctl enable NetworkManager

# SSH
if [[ "$INSTALL_SSH" =~ ^[Yy]$ ]]; then
    systemctl enable sshd
fi

# Bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch
grub-mkconfig -o /boot/grub/grub.cfg

# Create user and sudo
if [[ "$CREATE_USER" =~ ^[Yy]$ ]]; then
    useradd -m -G wheel "$USERNAME"
    echo "$USERNAME:$(cat /user_pass)" | chpasswd
    # Enable wheel group in sudoers
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
fi

# Cleanup
rm -f /chroot_vars /root_pass /user_pass /chroot_setup.sh
CHROOT_SCRIPT

chmod +x /mnt/chroot_setup.sh
arch-chroot /mnt /bin/bash /chroot_setup.sh

info "Installation complete!"
echo ""
echo -e "${GREEN}You can now reboot.${NC}"
echo -e "${YELLOW}Remember to remove the installation medium!${NC}"
echo ""
read -p "Reboot now? [y/N]: " REBOOT
if [[ "$REBOOT" =~ ^[Yy]$ ]]; then
    umount -R /mnt
    reboot
fi

