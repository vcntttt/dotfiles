# mise (runtime manager)
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# starship (prompt)
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# zoxide (better cd)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi
