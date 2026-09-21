#!/bin/bash

if command -v clicklockd &> /dev/null; then
	echo "clicklockd is already installed"
	exit 0
fi

current_dir=$(pwd)
dir=$(mktemp -d -t clicklockd_XXXXXX)
project_dir="$dir/clicklockd"

cleanup() {
    rm -rf "$dir"
	cd "$current_dir"
}

trap cleanup EXIT

sudo apt-get update
sudo apt-get install build-essential libudev-dev --yes

git clone --depth=1 https://github.com/germag/clicklockd.git "$project_dir"
cd "$project_dir"

make
sudo make install

cd "$current_dir"

sudo tee /etc/systemd/system/clicklockd.service << 'EOF'
[Unit]
Description=highlight or drag without holding down the mouse button

[Service]
ExecStart=/usr/local/bin/clicklockd --holding-time 0.5s

[Install]
WantedBy=multi-user.target
EOF

# sudo systemctl daemon-reload
# sudo systemctl restart clicklockd.service

sudo systemctl enable --now clicklockd.service
