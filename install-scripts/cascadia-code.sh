#!/bin/bash

if [ -f ~/.local/share/fonts/CascadiaCode-Regular.ttf ]; then
	echo "CascadiaCode fonts are already installed"
	exit 0
fi

dir=$(mktemp --directory -t cascadia-code_XXXXXX)
file="$dir/cascadia-code.zip"

cleanup() {
	rm -rf "$dir"
}

trap cleanup EXIT

curl -SL \
	--output "$file" \
	https://github.com/microsoft/cascadia-code/releases/download/v2407.24/CascadiaCode-2407.24.zip

unzip -qj "$file" "ttf/static/*.ttf" -d "$dir/ttf"
mkdir -p ~/.local/share/fonts/
mv "$dir/ttf/"*.ttf ~/.local/share/fonts/
