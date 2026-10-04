#!/bin/bash

change-theme() {
	theme=$1
	if [[ $theme != "dark" && $theme != "light" ]]; then
		echo "invalid theme: $theme."
		echo "Valid options: dark or light"
		return
	fi
	sedi "s/export THEME_STYLE=.*/export THEME_STYLE=\"$theme\"/" ~/.zshenv
	if [[ $theme == "dark" ]]; then
		sedi '\#themes#c\    "~/.config/alacritty/themes/rose-pine-moon.toml"' ~/.config/alacritty/alacritty.toml
		sedi 's/--theme=.*/--theme=Coldark-Dark/' ~/.config/bat/config
		sedi 's/set -g @theme_style.*/set -g @theme_style "dark"/' ~/.config/tmux/tmux.conf
		sedi 's/local theme_style =.*/local theme_style = "dark"/' ~/.config/nvim/lua/user/plugins/colorschemes.lua
		sedi 's/set background=.*/set background=dark/' ~/.vim/vimrc
		sedi 's/colorscheme.*/colorscheme catppuccin/' ~/.vim/vimrc
		sedi "s/export LS_COLORS=.*/export LS_COLORS=\"\$(vivid generate snazzy)\"/" ~/.zshenv
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2> /dev/null
	else
		sedi '\#themes#c\    "~/.config/alacritty/themes/neopaper.toml"' ~/.config/alacritty/alacritty.toml
		sedi 's/--theme=.*/--theme=GitHub/' ~/.config/bat/config
		sedi 's/set -g @theme_style.*/set -g @theme_style "light"/' ~/.config/tmux/tmux.conf
		sedi 's/local theme_style =.*/local theme_style = "light"/' /home/wcs/.config/nvim/lua/user/plugins/colorschemes.lua
		sedi 's/set background=.*/set background=light/' ~/.vim/vimrc
		sedi 's/colorscheme.*/colorscheme PaperColor/' ~/.vim/vimrc
		sedi "s/export LS_COLORS=.*/export LS_COLORS=\"\$(vivid generate catppuccin-latte)\"/" ~/.zshenv
		gsettings set org.gnome.desktop.interface color-scheme 'default' 2> /dev/null
	fi
	source ~/.zshenv
	tmux set-environment THEME_STYLE "$theme" 2> /dev/null
	tmux source-file ~/.config/tmux/tmux.conf 2> /dev/null
}

sedi() {
	sed -i "$1" $(realpath "$2") 2> /dev/null
}

change-theme $1
