#!/bin/bash

if command -v xremap &> /dev/null; then
	echo "xremap is already installed"
	exit 0
fi

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config=$(realpath "$BASEDIR/../config-files/etc/xremap/config.yml")
dir=$(mktemp -d -t xremap_XXXXXX)
file="$dir/xremap.zip"

cleanup() {
    rm -rf "$dir"
}

trap cleanup EXIT

curl -SL \
	--output "$file" \
	https://github.com/xremap/xremap/releases/download/v0.15.13/xremap-linux-x86_64-full.zip

unzip "$file" -d "$dir"
sudo install "$dir/xremap" -Dm755 /usr/local/bin/xremap

# https://github.com/xremap/xremap/blob/master/doc/running_with_sudo.md
# https://extensions.gnome.org/extension/5060/xremap/

if [[ "$XDG_CURRENT_DESKTOP" =~ "GNOME" ]] && [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	if ! rg -q '<allow user="root"/>' /usr/share/dbus-1/session.conf; then
		echo "allowing root in dbus-1/session"
		sudo sed -i "/<policy context=\"default\">/a\    <allow user=\"root\"/>" /usr/share/dbus-1/session.conf
	fi
fi

sudo modprobe uinput
echo uinput | sudo tee /etc/modules-load.d/uinput.conf

echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/70-uinput.rules

sudo useradd --no-create-home --shell /bin/false --user-group --groups input --system xremap

sudo groupadd --system xremap-wcs
sudo usermod --append --groups xremap-wcs wcs

sudo mkdir -p /etc/xremap
sudo chown xremap:xremap "$config"
sudo chmod 644 "$config"
sudo ln -f "$config" /etc/xremap/conf.yml

# https://github.com/xremap/xremap/blob/master/doc/running_as_system_service.md

sudo tee /etc/systemd/system/xremap.service << 'EOF'
[Unit]
Description=Xremap
After=default.target

[Service]
ExecStart=/usr/local/bin/xremap --desktop=socket --watch=config --mouse --device 'YICHIP Wireless Device Mouse' /etc/xremap/conf.yml
Restart=no
StandardOutput=journal
StandardError=journal
User=xremap
Group=xremap
SupplementaryGroups=input
RuntimeDirectory=xremap
RuntimeDirectoryMode=0755
RuntimeDirectoryPreserve=yes
Environment=RUST_LOG=warn

# Uncomment the following lines for the socket variant.
# Remember to enter the right username and their corresponding uid.
# To get the uid of the current user run "id" in the terminal, and `sudo -u username id` for other users.
ExecStartPre=install --directory --mode 2770 --owner xremap --group xremap-wcs /run/xremap/1000
SupplementaryGroups=xremap-wcs

[Install]
WantedBy=default.target
EOF

# sudo systemctl daemon-reload
# sudo systemctl restart xremap.service

sudo systemctl enable xremap.service
