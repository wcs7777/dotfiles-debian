#!/bin/bash

if command -v firefox &> /dev/null; then
	echo "firefox is already installed"
	exit 0
fi

sudo apt-get remove firefox-esr
rm -rf ~/.cache/mozilla/
rm -rf ~/.mozilla/

sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
echo -e "Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000" | sudo tee /etc/apt/preferences.d/mozilla > /dev/null

sudo apt-get update
sudo apt-get install firefox --yes
