#!/bin/bash

if command -v xremap &> /dev/null; then
	echo "xremap is already installed"
	return 0
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

# https://extensions.gnome.org/extension/5060/xremap/

sudo modprobe uinput
echo uinput | sudo tee /etc/modules-load.d/uinput.conf
echo 'ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="xremap", ENV{ID_INPUT_MOUSE}="1"' | sudo tee /etc/udev/rules.d/99-xremap-mouse.rules
