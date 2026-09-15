#!/bin/bash

if command -v nix &> /dev/null; then
	echo "nix is already installed"
	exit 0
fi

sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
