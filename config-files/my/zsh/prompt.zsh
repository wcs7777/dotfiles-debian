python_venv() {
    [[ -z $VIRTUAL_ENV ]] && return
	echo "%F{cyan}(venv)%f"
}

git_info() {
    local git="git"
    case "$PWD" in
        /mnt/c/* | /mnt/d/* | "$HOME/win/"*)
            git="git.exe"
            ;;
    esac
    command -v "$git" >/dev/null 2>&1 || return
	local branch=$(timeout 3s "$git" branch --show-current 2>/dev/null)
	if [[ -z $branch ]]; then
		local ref=$(timeout 3s "$git" rev-parse --short HEAD 2>/dev/null)
		if [[ -n $ref ]]; then
			local tag=$(timeout 3s "$git" tag --points-at HEAD 2>/dev/null | head -1)
			if [[ -n $tag ]]; then
				branch="#$tag"
			else
				branch="@$ref"
			fi
		fi
	fi
    [[ -z $branch ]] && return
	local git_color="red"
    if timeout 3s "$git" diff --quiet 2>/dev/null &&
       timeout 3s "$git" diff --cached --quiet 2>/dev/null; then
        git_color=blue
    fi
	echo "%F{${git_color}}($branch)%f"
}

segments() {
	local g=$(git_info)
	local v=$(python_venv)
	local s="$g$v"
    [[ -z $s ]] && return
	echo "$s "
}

setopt PROMPT_SUBST
PROMPT='$(segments)%2~ > '
