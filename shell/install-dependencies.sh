#!/usr/bin/env bash

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
PROFILE="${1:-desktop}"

source "$DOTFILES/shell/dependencies/list.sh"

print_help() {
  cat <<'EOF'
Uso: install-dependencies [desktop|core|server]

Perfiles:
  desktop  Instala CLI base, stack de Hyprland y apps del notebook/desktop
  core     Instala solo CLI base y dependencias de zsh/plugins
  server   Igual que core; pensado para hosts sin GUI
EOF
}

ensure_pacman() {
  if ! command -v pacman >/dev/null 2>&1; then
    echo "Este instalador esta pensado para Arch/CachyOS y requiere pacman."
    exit 1
  fi
}

append_pkgs() {
  local array_name="$1"
  local -n source_pkgs="$array_name"
  local pkg

  for pkg in "${source_pkgs[@]}"; do
    PACMAN_PKGS+=("$pkg")
  done
}

append_aur_pkgs() {
  local array_name="$1"
  local -n source_pkgs="$array_name"
  local pkg

  for pkg in "${source_pkgs[@]}"; do
    AUR_PKGS+=("$pkg")
  done
}

install_pacman_pkgs() {
  if (( ${#PACMAN_PKGS[@]} == 0 )); then
    return 0
  fi

  echo "==> Instalando paquetes pacman (${#PACMAN_PKGS[@]})"
  sudo pacman -S --needed "${PACMAN_PKGS[@]}"
}

install_aur_pkgs() {
  if (( ${#AUR_PKGS[@]} == 0 )); then
    return 0
  fi

  "$DOTFILES/.local/bin/install-yay"

  echo "==> Instalando paquetes AUR (${#AUR_PKGS[@]})"
  yay -S --needed "${AUR_PKGS[@]}"
}

main() {
  case "$PROFILE" in
    desktop)
      append_pkgs CORE_PACMAN_PKGS
      append_pkgs DESKTOP_PACMAN_PKGS
      append_pkgs DESKTOP_APP_PACMAN_PKGS
      append_aur_pkgs DESKTOP_AUR_PKGS
      ;;
    core|server)
      append_pkgs CORE_PACMAN_PKGS
      ;;
    -h|--help|help)
      print_help
      exit 0
      ;;
    *)
      echo "Perfil no valido: $PROFILE"
      print_help
      exit 1
      ;;
  esac

  ensure_pacman
  install_pacman_pkgs
  install_aur_pkgs

  if [[ -f "$DOTFILES/.config/dotfiles/host" ]]; then
    echo "==> Aplicando overrides locales por host"
    bash "$DOTFILES/.local/bin/apply-host-config"
  fi

  echo "==> Instalando plugins y paquetes de zsh"
  bash "$DOTFILES/shell/plugins/install.sh"

  echo "✔ Dependencias listas para el perfil '$PROFILE'"
}

PACMAN_PKGS=()
AUR_PKGS=()

main
