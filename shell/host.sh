DOTFILES_ROOT="${DOTFILES:-$HOME/dotfiles}"
DOTFILES_HOST_FILE="${DOTFILES_HOST_FILE:-$DOTFILES_ROOT/.config/dotfiles/host}"
DOTFILES_HOST_VALUES="desktop, notebook, homelab"

read_dotfiles_host_value() {
  local line=""
  local cleaned=""
  local selected=""

  if [[ ! -f "$DOTFILES_HOST_FILE" ]]; then
    return 1
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    cleaned="${line%%#*}"
    cleaned="${cleaned//$'\n'/}"
    cleaned="${cleaned//$'\r'/}"
    cleaned="${cleaned//$'\t'/}"
    cleaned="${cleaned// /}"

    if [[ -z "$cleaned" ]]; then
      continue
    fi

    if [[ -n "$selected" && "$selected" != "$cleaned" ]]; then
      echo "Dotfiles: hay multiples hosts activos en $DOTFILES_HOST_FILE. Deja solo uno. Valores: $DOTFILES_HOST_VALUES" >&2
      return 1
    fi

    selected="$cleaned"
  done < "$DOTFILES_HOST_FILE"

  if [[ -z "$selected" ]]; then
    return 1
  fi

  printf '%s\n' "$selected"
}

load_dotfiles_host() {
  local host_value="${DOTFILES_HOST:-}"

  if [[ -z "$host_value" ]]; then
    if ! host_value="$(read_dotfiles_host_value)"; then
      unset DOTFILES_HOST
      echo "Dotfiles: se requiere especificar el host en $DOTFILES_HOST_FILE. Valores disponibles: $DOTFILES_HOST_VALUES" >&2
      return 1
    fi
  fi

  case "$host_value" in
    desktop|notebook|homelab)
      export DOTFILES_HOST="$host_value"
      ;;
    *)
      unset DOTFILES_HOST
      echo "Dotfiles: host no valido '$host_value' en $DOTFILES_HOST_FILE. Valores disponibles: $DOTFILES_HOST_VALUES" >&2
      return 1
      ;;
  esac
}

load_dotfiles_host
