# Warp usa su propio sistema de hooks y resaltado.
# Si estamos en Warp, salimos inmediatamente del script.
if [[ -n "$WARP_IS_LOCAL_SHELL_SESSION" ]]; then
  return 0
fi

PLUGINS_DIR="$HOME/git-packages/zsh"

source "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$PLUGINS_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$PLUGINS_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# zsh-abbr (pacman/aur)
source /usr/share/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh
abbr_sync_from_aliases() {
  local abbr_file="${ABBR_USER_ABBREVIATIONS_FILE:-$HOME/.config/zsh-abbr/user-abbreviations}"

  mkdir -p "${abbr_file:h}"

  # Reset persistente
  : > "$abbr_file"

  # Recargar y reimportar aliases (silenciar output normal)
  abbr load >/dev/null
  abbr import-aliases >/dev/null
}

# keybinds for history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down