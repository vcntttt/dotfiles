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

# keybinds for history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# convertir aliases -> abreviaciones
if ! abbr list | grep -q gs; then
  abbr import-aliases
fi