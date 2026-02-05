git_info() {
	case "$PWD" in
		/mnt/c/* | \
		/mnt/d/* | \
		~/win/* | \
		"$HOME/win/*")
			echo ""
			return 0
			;;
	esac
	local branch=""
	if command -v git >/dev/null 2>&1; then
		branch=$(timeout 2s git branch --show-current 2>/dev/null)
		if [[ -z $branch ]]; then
			local ref=$(timeout 2s git rev-parse --short HEAD 2>/dev/null)
			if [[ -n $ref ]]; then
				branch="@$ref"
			fi
		fi
		if [[ -n $branch ]]; then
			local git_color="red"
			if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
				git_color="blue"
			fi
			branch=" %F{${git_color}}($branch)%f"
		fi
	fi
	echo "$branch"
}

setopt PROMPT_SUBST
PROMPT='%2~$(git_info) > '
