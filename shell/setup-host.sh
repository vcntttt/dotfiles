#!/usr/bin/env bash

set -euo pipefail

DOTFILES_ROOT="${DOTFILES:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}"
TARGET_HOME="${TARGET_HOME:-$HOME}"
HOST_FILE="${DOTFILES_HOST_FILE:-$TARGET_HOME/.config/dotfiles/host}"

usage() {
    cat <<'EOF'
Uso: setup-host.sh <desktop|notebook|caburgua>

El script respalda los destinos en conflicto, escribe el host local y aplica
solo los paquetes Stow correspondientes.
EOF
}

die() {
    echo "setup-host: $*" >&2
    exit 1
}

backup_target() {
    local source="$1"
    local target="$2"
    local backup_root="$3"
    local relative_path="${target#"$TARGET_HOME/"}"
    local backup_path="$backup_root/$relative_path"
    local source_real=""
    local target_real=""

    if [[ ! -e "$target" && ! -L "$target" ]]; then
        return 0
    fi

    if [[ -L "$target" ]]; then
        source_real="$(readlink -f -- "$source")"
        target_real="$(readlink -f -- "$target" || true)"
        if [[ -n "$target_real" && "$target_real" == "$source_real" ]]; then
            return 0
        fi
    fi

    mkdir -p "$(dirname -- "$backup_path")"
    mv -- "$target" "$backup_path"
    echo "setup-host: respaldo $relative_path -> $backup_path"
}

backup_package_conflicts() {
    local package="$1"
    local backup_root="$2"
    local source relative_path target

    while IFS= read -r -d '' source; do
        relative_path="${source#"$DOTFILES_ROOT/$package/"}"
        target="$TARGET_HOME/$relative_path"
        backup_target "$source" "$target" "$backup_root"
    done < <(find "$DOTFILES_ROOT/$package" \( -type f -o -type l \) -print0)
}

unstow_profiles() {
    local package

    for package in common shell-common graphical desktop notebook caburgua; do
        stow --dir="$DOTFILES_ROOT" --target="$TARGET_HOME" --no-folding --delete "$package" >/dev/null 2>&1 || true
    done
}

main() {
    local host="${1:-}"
    local timestamp backup_root
    local -a packages=(shell-common)

    [[ -n "$host" && "$host" != -* ]] || {
        usage
        exit 2
    }
    [[ -d "$DOTFILES_ROOT/.git" ]] || die "no parece un repo de dotfiles: $DOTFILES_ROOT"
    command -v stow >/dev/null 2>&1 || die "stow no esta instalado"

    case "$host" in
        desktop|notebook)
            packages+=(common graphical "$host")
            ;;
        caburgua)
            packages+=(caburgua)
            ;;
        *)
            usage
            exit 2
            ;;
    esac

    timestamp="$(date +%Y%m%d-%H%M%S)"
    backup_root="$TARGET_HOME/.local/state/dotfiles/backups/$timestamp-$host"

    unstow_profiles

    for package in "${packages[@]}"; do
        backup_package_conflicts "$package" "$backup_root"
    done

    mkdir -p "$(dirname -- "$HOST_FILE")"
    printf '%s\n' "$host" > "$HOST_FILE"
    export DOTFILES_HOST="$host"

    stow --dir="$DOTFILES_ROOT" --target="$TARGET_HOME" --no-folding --stow "${packages[@]}"

    echo "setup-host: host activo: $host"
    echo "setup-host: paquetes aplicados: ${packages[*]}"
    echo "setup-host: respaldos: $backup_root"
}

main "$@"
