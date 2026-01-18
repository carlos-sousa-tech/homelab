#!/bin/bash

echo "Installing coolercontrol"
sudo dnf install dnf-plugins-core
sudo dnf copr enable codifryed/CoolerControl
sudo dnf install coolercontrol
sudo systemctl enable --now coolercontrold
