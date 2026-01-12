custom_prompt() {
	local git_branch=""
	if command -v git >/dev/null 2>&1; then
		git_branch=$(timeout 2s git branch --show-current 2>/dev/null)
		if [[ -z $git_branch ]]; then
			git_branch=$(timeout 2s git rev-parse --short HEAD 2>/dev/null)
			if [[ -n $git_branch ]]; then
				git_branch="@$git_branch"
			fi
		fi
		if [[ -n $git_branch ]]; then
			git_branch=" %F{yellow}($git_branch)%f"
		fi
	fi
	echo "%2~${git_branch} > "
}
setopt PROMPT_SUBST
PROMPT='$(custom_prompt)'
