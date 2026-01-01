#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
PLUGINS_DIR="$HOME/git-packages/zsh"

source "$DOTFILES/shell/plugins/list.sh"

mkdir -p "$PLUGINS_DIR"

echo "==> Instalando plugins Git"
for entry in "${ZSH_GIT_PLUGINS[@]}"; do
  repo="${entry%%:*}"
  name="${repo##*/}"
  dir="$PLUGINS_DIR/$name"

  if [[ ! -d "$dir" ]]; then
    echo "  - Clonando $repo"
    git clone "https://github.com/$repo.git" "$dir"
  else
    echo "  - $name ya existe"
  fi
done

echo "==> Instalando paquetes pacman"
for pkg in "${ZSH_PACMAN_PKGS[@]}"; do
  pacman -Qi "$pkg" &>/dev/null || sudo pacman -S --needed "$pkg"
done

echo "==> Instalando paquetes AUR"
for pkg in "${ZSH_AUR_PKGS[@]}"; do
  pacman -Qi "$pkg" &>/dev/null || yay -S --needed "$pkg"
done

echo "✔ Instalación completada"
