#!/bin/bash

if command -v tmux-sessionizer &> /dev/null; then
	echo "tmux-sessionizer is already installed"
	exit 0
fi

curl -sLS https://raw.githubusercontent.com/ThePrimeagen/tmux-sessionizer/refs/heads/master/tmux-sessionizer --output ~/.local/bin/tmux-sessionizer
chmod +x ~/.local/bin/tmux-sessionizer
