#!/bin/bash

if command -v nvim &> /dev/null; then
	echo "nvim is already installed"
	exit 0
fi
curl -SL \
	--output ~/.local/bin/nvim \
	https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage \
	&& chmod u+x ~/.local/bin/nvim
