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

clipcopy () {
	cat "${1:-/dev/stdin}" | clip.exe
}

mkcd() {
	mkdir -p -- "$1" && cd -P -- "$1"
}

win-cd() {
	(cd "$(readlink -f ${1:-.})" && explorer.exe .)
}

win-notify() {
	pwsh.exe -NonInteractive -NoProfile -Command "New-BurntToastNotification -Text '$1'"
}

win-notify-sound  () {
	pwsh.exe -NonInteractive -NoProfile -Command "New-BurntToastNotification -Sound Call3 -Text '$1'"
}
