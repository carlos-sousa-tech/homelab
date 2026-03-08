# Arch Linux Bootstraper

## Useful Commands / Helpers

### Set Keyboard Layout in Installation Env

- Show available with `localectl list-keymaps`

- Change with `loadkeys de-latin1`

### No Cable, WLAN Only

#### In Arch Installation step

You can use `iwctl`

- List Devices `device list`

- Turn On if Needed `device <name> set-property Powered On`

- Scan Networks `station <name> scan`

- Show Networks Found `station <name> get-networks`

- Connect with: `station <name> connect <SSID>`

All in one go would be: `iwctl --passphrase <passphrase> station <name> connect <SSID>`


#### In your Installation

Just use `nmtui`

## Using the Auto Installer
- Get the auto-installer to your system
    - scp: `pacman -Sy openssh` > `passwd` > `scp install_arch.sh root@ip:~/`
    - curl: `curl -O URL` > `chmod +x install_arch.sh` > `./install.sh`

## Using the Bootstraper
- Get the bootstraper to your system
    - scp: `scp arch_bootstrap user@ip:~/`
    - git: `git clone https://github.com/carlos-sousa-tech/homelab`

- Navigate to the bootstrapper directory
    - `cd homelab/arch_bootstrap`

- [Optional] Configure the settings
    - `vi configs/config.json`

- Run the bootstraper
    - `./bootstrap_arch.sh`

## Roadmap
Note: Once everything is completed, roadmap should be replaced by features

### Planned

- [ ] Configure System
    - [ ] Setup hyprland
    - [ ] Setup date / time
    - [ ] Setup Waybar
- [ ] Test system on VM
- [ ] Test sytem Live (with gaming!)

### Completed

## Resources
- [Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
