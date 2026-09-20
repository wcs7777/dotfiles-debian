#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"${BASEDIR}/../install-scripts/nix-home-manager.sh"
"${BASEDIR}/gnome.sh"

zsh -c "home-manager switch"

[[ $SHELL != /bin/zsh ]] && chsh -s /bin/zsh
