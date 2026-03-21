DOTFILES_ROOT="${DOTFILES:-$HOME/dotfiles}"
DOTFILES_HOST_FILE="${DOTFILES_HOST_FILE:-$DOTFILES_ROOT/.config/dotfiles/host}"

load_dotfiles_host() {
  local host_value="${DOTFILES_HOST:-}"

  if [[ -z "$host_value" && -f "$DOTFILES_HOST_FILE" ]]; then
    IFS= read -r host_value < "$DOTFILES_HOST_FILE"
  fi

  host_value="${host_value//$'\n'/}"
  host_value="${host_value//$'\r'/}"
  host_value="${host_value//$'\t'/}"
  host_value="${host_value// /}"

  case "$host_value" in
    desktop|notebook|homelab)
      export DOTFILES_HOST="$host_value"
      ;;
    *)
      export DOTFILES_HOST="desktop"
      ;;
  esac
}

load_dotfiles_host
