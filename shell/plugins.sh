# Warp usa su propio sistema de hooks y resaltado.
# Si estamos en Warp, salimos inmediatamente del script.
if [[ -n "$WARP_IS_LOCAL_SHELL_SESSION" ]]; then
  return 0
fi

PLUGINS_DIR="$HOME/git-packages/zsh"

clone_plugin_if_needed() {
  local repo_url=$1
  local plugin_dir=$2

  # Clona el plugin si no existe
  if [[ ! -d "$plugin_dir" ]]; then
    git clone "$repo_url" "$plugin_dir" >/dev/null 2>&1
  fi
}

# Declaración de los plugins con sus URLs y archivos principales
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

    [[ -f "$plugin_path" ]] && source "$plugin_path"
  done
}

load_plugins

# Plugin adicional: sudo.zsh
source ~/dotfiles/shell/sudo.zsh
