#!/bin/bash

if command -v az &> /dev/null; then
	echo "az is already installed"
	exit 0
fi

# Download and install the Microsoft signing key
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
  gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

# Add the Azure CLI software repository
AZ_DIST=$(. /etc/os-release && echo "$VERSION_CODENAME")
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources > /dev/null

# Update repository information and install the azure-cli package:
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install azure-cli --yes
