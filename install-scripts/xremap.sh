#!/bin/bash

if command -v xremap &> /dev/null; then
	echo "xremap is already installed"
	exit 0
fi

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

basedir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir=$(realpath "$basedir/../config-files/etc/xremap")

sudo mkdir -p /etc/xremap

sudo chown root:root "$config_dir/mouse.yml"
sudo chmod 644 "$config_dir/mouse.yml"
sudo ln -f "$config_dir/mouse.yml" /etc/xremap/mouse.yml

sudo chown root:root "$config_dir/keyboard.yml"
sudo chmod 644 "$config_dir/keyboard.yml"
sudo ln -f "$config_dir/keyboard.yml" /etc/xremap/keyboard.yml
