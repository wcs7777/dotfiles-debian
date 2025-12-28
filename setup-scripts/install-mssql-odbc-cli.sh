#!/bin/bash

if command -v sqlcmd &> /dev/null; then
	echo "mssql tools already installed"
	exit 0
fi

id=$(. /etc/os-release && echo "$ID")
version=$(. /etc/os-release && echo "$VERSION_ID")

curl -sLSO https://packages.microsoft.com/config/$id/$version/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql18 mssql-tools18 --yes
