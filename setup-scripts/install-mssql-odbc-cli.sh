#!/bin/bash

if command -v sqlcmd &> /dev/null; then
	echo "mssql tools already installed"
	exit 0
fi

DEBIAN_VERSION=$(lsb_release -rs)
curl -sLSO https://packages.microsoft.com/config/debian/$DEBIAN_VERSION/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql18 mssql-tools18 --yes
