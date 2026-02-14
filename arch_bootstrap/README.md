# Arch Linux Bootstraper

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
