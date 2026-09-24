#!/bin/bash

repository_file=/etc/apt/sources.list.d/trixie-backports.sources

if [ -f "$repository_file" ]; then
	echo "trixie-backports is already installed"
	exit 0
fi

sudo tee "$repository_file" << 'EOF'
Types: deb deb-src
URIs: http://deb.debian.org/debian
Suites: trixie-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
Enabled: yes
EOF
