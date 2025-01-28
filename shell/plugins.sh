PLUGINS_DIR="$HOME/git-packages/zsh"

clone_plugin_if_needed() {
  local repo_url=$1
  local plugin_dir=$2

  # Revisa si la carpeta del plugin existe, si no, lo clona
  if [[ ! -d "$plugin_dir" ]]; then
    echo "La carpeta de $(basename "$plugin_dir") no existe. Clonando..."
    git clone "$repo_url" "$plugin_dir"
    if [[ $? -ne 0 ]]; then
      echo "Error al clonar $repo_url"
      return 1
    fi
  fi
}

# Declaración de los plugins con sus URLs y rutas al archivo principal
declare -A PLUGINS=(
  ["fast-syntax-highlighting"]="git@github.com:zdharma-continuum/fast-syntax-highlighting.git|fast-syntax-highlighting.plugin.zsh"
  ["zsh-autosuggestions"]="git@github.com:zsh-users/zsh-autosuggestions.git|zsh-autosuggestions.zsh"
  # formato "URL|ruta_al_archivo"
)

mkdir -p "$PLUGINS_DIR"

for plugin in "${(@k)PLUGINS}"; do
  IFS='|' read -r repo_url main_file <<< "${PLUGINS[$plugin]}"
  plugin_dir="$PLUGINS_DIR/$plugin"
  clone_plugin_if_needed "$repo_url" "$plugin_dir"
done

load_plugins() {
  for plugin in "${(@k)PLUGINS}"; do
    IFS='|' read -r _ main_file <<< "${PLUGINS[$plugin]}"
    plugin_dir="$PLUGINS_DIR/$plugin"
    plugin_path="$plugin_dir/$main_file"

    if [[ -f "$plugin_path" ]]; then
      source "$plugin_path"
    else
      echo "Archivo principal para $plugin no encontrado en $plugin_path"
    fi
  done
}

load_plugins

# plugins adicionales
source ~/dotfiles/shell/external/sudo.zsh

# ---- olvidados ----
#source ~/git-packages/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down
