# alias lazyvim="NVIM_APPNAME=snvim/lazyvim nvim"
alias deltaa="delta --no-gitconfig --config ~/.config/delta"
alias docker-rmi-dangling="docker image rm \`docker images -qa -f 'dangling=true'\`"
alias exa="eza -lF --icons --color=never --group-directories-first"
alias grep='grep --color=auto'
alias hs='history 1 | rg'
alias hsi='history 1 | rg -i'
alias permissions="stat -c '%a %U:%G %n'"

dark-theme() {
	~/.my/scripts/change-theme.sh dark
}

light-theme() {
	~/.my/scripts/change-theme.sh light
}

mkcd() {
	mkdir -p -- "$1" && cd -P -- "$1"
}
