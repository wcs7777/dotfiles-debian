#!/bin/bash

if [ -f ~/.local/bin/mise ]; then
	echo "mise already installed"
	exit 0
fi

curl https://mise.run | sh
