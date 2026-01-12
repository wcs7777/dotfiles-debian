autoload -U colors && colors

# --- Git prompt cache ---
typeset -g __GIT_PROMPT_CACHE=""
typeset -g __GIT_PROMPT_DIR=""

update_git_prompt_cache() {
  # Only recompute if directory changed
  if [[ "$PWD" == "$__GIT_PROMPT_DIR" ]]; then
    return
  fi

  __GIT_PROMPT_DIR="$PWD"
  __GIT_PROMPT_CACHE=""

  if ! command -v git >/dev/null 2>&1; then
    return
  fi

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return
  fi

  local git_ref git_color

  # Branch or detached
  git_ref=$(git branch --show-current 2>/dev/null)
  if [[ -z "$git_ref" ]]; then
    git_ref="detached@$(git rev-parse --short HEAD 2>/dev/null)"
  fi

  # Clean vs dirty
  if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
    git_color="yellow"
  else
    git_color="red"
  fi

  __GIT_PROMPT_CACHE=" %F{${git_color}}($git_ref)%f"
}

# Run before each prompt
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_git_prompt_cache

setopt PROMPT_SUBST

# --- Prompt ---
PROMPT='%2~${__GIT_PROMPT_CACHE} > '
