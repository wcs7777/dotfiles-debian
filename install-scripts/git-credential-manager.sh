#!/bin/bash

if command -v git-credential-manager &> /dev/null; then
	echo "git-credential-manager is already installed"
	exit 0
fi

dir=$(mktemp --directory -t gcm_XXXXXX)
file="$dir/gcm.deb"

cleanup() {
	rm -rf "$dir"
}

trap cleanup EXIT

sudo apt-get update
sudo apt-get install gpg pass --yes

curl -SL \
	--output "$file" \
	https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.9.1/gcm-linux-x64-2.9.1.deb

sudo apt-get install "$file"

git-credential-manager configure
gpg --full-generate-key
pass init "$(gpg --list-secret-keys --with-colons | awk -F: '/^fpr:/ {print $10; exit}')"
git config --global credential.credentialStore gpg
