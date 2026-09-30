# alias lazyvim="NVIM_APPNAME=snvim/lazyvim nvim"
alias deltaa="delta --no-gitconfig --config ~/.config/delta"
alias docker-rmi-dangling="docker image rm \`docker images -qa -f 'dangling=true'\`"
alias exa="eza -lF --icons --color=never --group-directories-first"
alias grep='grep --color=auto'
alias h1='history 1'
alias hs='history 1 | rg'
alias hsi='history 1 | rg -i'
alias permissions="stat -c '%a %U:%G %n'"
alias rnvim="nvim -R"
alias sudonvim="sudo -E /home/wcs/.local/bin/nvim"

change-theme() {
	theme=$1
	if [[ $theme != "dark" && $theme != "light" ]]; then
		echo "invalid theme: $theme."
		echo "Valid options: dark or light"
		return
	fi
	sed -i "s/export THEME_STYLE=.*/export THEME_STYLE=\"$theme\"/" ~/.zshenv
	source ~/.zshenv
	if [[ $theme == "dark" ]]; then
		sed -i '\#themes#c\    "~/.config/alacritty/themes/rose-pine-moon.toml"' ~/.config/alacritty/alacritty.toml 2> /dev/null
		sed -i 's/--theme=.*/--theme=Coldark-Dark/' ~/.config/bat/config 2> /dev/null
		sed -i 's/set -g @theme_style.*/set -g @theme_style "dark"/' ~/.config/tmux/tmux.conf 2> /dev/null
	else
		sed -i '\#themes#c\    "~/.config/alacritty/themes/neopaper.toml"' ~/.config/alacritty/alacritty.toml 2> /dev/null
		sed -i 's/--theme=.*/--theme=GitHub/' ~/.config/bat/config 2> /dev/null
		sed -i 's/set -g @theme_style.*/set -g @theme_style "light"/' ~/.config/tmux/tmux.conf 2> /dev/null
	fi
	tmux set-environment THEME_STYLE "$theme" 2> /dev/null
	tmux source-file ~/.config/tmux/tmux.conf 2> /dev/null
}

dark-theme() {
	change-theme dark
}

light-theme() {
	change-theme light
}

mkcd() {
	mkdir -p -- "$1" && cd -P -- "$1"
}
