#!/bin/bash

if command -v func &> /dev/null; then
	echo "func already installed"
	exit 0
fi

DEBIAN_VERSION=$(lsb_release -rs)
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-prod.gpg > /dev/null
curl -sLS https://packages.microsoft.com/config/debian/$DEBIAN_VERSION/prod.list | sudo tee /etc/apt/sources.list.d/microsoft-prod.list > /dev/null
sudo chown root:root /usr/share/keyrings/microsoft-prod.gpg
sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install azure-functions-core-tools-4 --yes
