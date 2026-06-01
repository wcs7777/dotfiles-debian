#!/bin/bash
if command -v func &> /dev/null; then
	echo "func is already installed"
	exit 0
fi

# Install the Microsoft package repository GPG key, to validate package integrity
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

# Set up the APT source list before doing an APT update.
# codename=$(lsb_release -cs)
codename="noble"
source_list="deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-${codename}-prod ${codename} main"
echo "$source_list" | sudo tee /etc/apt/sources.list.d/dotnetdev.list

# Update repository information and install the Core Tools package
sudo apt-get update
sudo apt-get install azure-functions-core-tools-4 --yes
