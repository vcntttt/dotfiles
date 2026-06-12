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
  local -A alias_names
  local line name

  mkdir -p "${abbr_file:h}"

  # Empezar desde una sesión limpia y reconstruir desde los aliases reales.
  abbr clear-session >/dev/null

  while IFS= read -r line; do
    name="${line#alias }"
    name="${name%%=*}"
    alias_names["$name"]=1
  done < <(alias)

  abbr load >/dev/null

  while IFS= read -r line; do
    name="${line#\"}"
    name="${name%%\"=*}"

    [[ -n "${alias_names[$name]}" ]] && continue

    abbr erase --user "$name" >/dev/null 2>&1 || true
  done < <(abbr list)

  abbr import-aliases >/dev/null
}

# keybinds for history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
