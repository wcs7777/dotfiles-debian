#!/bin/bash
if command -v func &> /dev/null; then
	echo "func is already installed"
	exit 0
fi

# Install the Microsoft package repository GPG key, to validate package integrity
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

# Set up the APT source list before doing an APT update.
codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
source_list=""
if [[ $(. /etc/os-release && echo $ID) == 'debian'  ]]; then
	release=$(. /etc/os-release && echo "$VERSION_ID" | cut -d '.' -f 1)
	if [[ $release > 12 ]]; then
		codename="bookworm"
		release="12"
	fi
	source_list="deb [arch=amd64] https://packages.microsoft.com/debian/${release}/prod ${codename} main"
else
	source_list="deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-${codename}-prod ${codename} main"
fi
echo "$source_list" | sudo tee /etc/apt/sources.list.d/dotnetdev.list

# Update repository information and install the Core Tools package
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install azure-functions-core-tools-4 --yes
