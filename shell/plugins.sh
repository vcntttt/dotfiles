PLUGINS_DIR="$HOME/git-packages/zsh"

clone_plugin_if_needed() {
  local repo_url=$1
  local plugin_dir=$2
  local plugin_file=$3
  local plugin_name=$(basename $plugin_dir)

# revisa si el plugin existe, si no lo clona
  if [[ ! -f "$plugin_dir/$plugin_file" ]]; then
    echo "El archivo $plugin_file no existe. Clonando $plugin_name..."
    git clone "$repo_url" "$plugin_dir"
  else
    echo "$plugin_name ya está instalado."
  fi
}

declare -A PLUGINS=(
  ["fast-syntax-highlighting"]="git@github.com:zdharma-continuum/fast-syntax-highlighting.git"
  ["zsh-autosuggestions"]="git@github.com:zsh-users/zsh-autosuggestions.git"
)

mkdir -p "$PLUGINS_DIR"

for plugin in "${(@k)PLUGINS}"; do
    repo_url=$(echo "${PLUGINS[$plugin]}" | awk '{print $1}')
    plugin_file=$(echo "${PLUGINS[$plugin]}" | awk '{print $2}')
    clone_plugin_if_needed "$repo_url" "$PLUGINS_DIR/$plugin" "$plugin_file"
done

source "$PLUGINS_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source ~/dotfiles/shell/zsh/sudo.zsh

# ---- olvidados ----
#source ~/git-packages/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down
