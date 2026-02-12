#!/bin/bash

# Terminate on any error
set -euo pipefail

# List of applications to install
PACKAGES=(
    "base-devel"
    "btop"
    "curl"
    "fastfetch"
    "git"
    "linux-headers"
    "neovim"
    "vim"
    "wget"
)

echo "Installing packages: ${PACKAGES[@]}"
echo ""

# Update package manager
echo "Updating package manager..."
sudo pacman -Sy

# Install each package
for package in "${PACKAGES[@]}"; do
    if pacman -Q "$package" &> /dev/null; then
        echo "  ✓ $package (already installed)"
    else
        echo "  → Installing $package..."
        if sudo pacman -S --noconfirm "$package" > /dev/null 2>&1; then
            echo "  ✓ $package installed successfully"
        else
            echo "  ✗ Failed to install $package"
            return 1
        fi
    fi
done

echo ""
echo "Package installation completed!"
