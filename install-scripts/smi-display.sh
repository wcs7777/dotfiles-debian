#!/bin/bash

if command -v smi-installer &> /dev/null; then
	echo "smi-installer is already installed"
	exit 0
fi

sudo apt-get update
sudo apt-get install dkms linux-headers-$(uname -r) build-essential libdrm-dev pkg-config --yes
sudo ./SMIUSBDisplay-driver.2.24.8.0.run
