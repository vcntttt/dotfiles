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

migrate_legacy_local_bin() {
    local legacy_bin="$TARGET_HOME/.local/bin"
    local legacy_real backup_path

    [[ -L "$legacy_bin" ]] || return 0

    legacy_real="$(readlink -f -- "$legacy_bin" || true)"
    [[ "$legacy_real" == "$DOTFILES_ROOT/.local/bin" ]] || return 0

    backup_path="$backup_root/.local/bin"
    mkdir -p "$(dirname -- "$backup_path")"
    mv -- "$legacy_bin" "$backup_path"
    echo "setup-host: migra enlace legado .local/bin -> $backup_path"
}

remove_obsolete_local_bin_links() {
    local name target target_real backup_path

    for name in herdr uv uvx; do
        target="$TARGET_HOME/.local/bin/$name"
        [[ -L "$target" ]] || continue

        target_real="$(readlink -m -- "$target")"
        [[ "$target_real" == "$DOTFILES_ROOT/shell-common/.local/bin/$name" ]] || continue

        backup_path="$backup_root/.local/bin/$name"
        mkdir -p "$(dirname -- "$backup_path")"
        mv -- "$target" "$backup_path"
        echo "setup-host: retira binario legado $name -> $backup_path"
    done
}

reload_active_hyprland() {
    command -v hyprctl >/dev/null 2>&1 || return 0
    hyprctl instances >/dev/null 2>&1 || return 0

    if ! hyprctl reload >/dev/null 2>&1; then
        echo "setup-host: advertencia: no se pudo recargar Hyprland" >&2
    fi
}

migrate_legacy_dotfiles_links() {
    local root path target relative_path backup_path
    local -a roots=(
        "$TARGET_HOME/.config"
        "$TARGET_HOME/.local/share/fastfetch"
        "$TARGET_HOME/.local/state/noctalia"
        "$TARGET_HOME/.icons"
        "$TARGET_HOME/.t3"
    )

    while IFS= read -r -d '' path; do
        [[ "$path" == "$backup_root"/* ]] && continue

        target="$(readlink -m -- "$path")"
        case "$target" in
            "$DOTFILES_ROOT/.config/"*|"$DOTFILES_ROOT/.local/"*|"$DOTFILES_ROOT/.icons/"*|"$DOTFILES_ROOT/.tmux.conf"|"$DOTFILES_ROOT/.npmrc")
                relative_path="${path#"$TARGET_HOME/"}"
                backup_path="$backup_root/$relative_path"
                mkdir -p "$(dirname -- "$backup_path")"
                mv -- "$path" "$backup_path"
                echo "setup-host: migra enlace legado $relative_path -> $backup_path"
                ;;
        esac
    done < <(
        for root in "${roots[@]}"; do
            [[ -e "$root" || -L "$root" ]] || continue
            find -P "$root" -maxdepth 4 -type l -print0
        done
        for path in "$TARGET_HOME/.tmux.conf" "$TARGET_HOME/.npmrc"; do
            [[ -L "$path" ]] && printf '%s\0' "$path"
        done
    )
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
    migrate_legacy_local_bin
    migrate_legacy_dotfiles_links
    remove_obsolete_local_bin_links

    for package in "${packages[@]}"; do
        backup_package_conflicts "$package" "$backup_root"
    done

    mkdir -p "$(dirname -- "$HOST_FILE")"
    printf '%s\n' "$host" > "$HOST_FILE"
    export DOTFILES_HOST="$host"

    stow --dir="$DOTFILES_ROOT" --target="$TARGET_HOME" --no-folding --stow "${packages[@]}"
    reload_active_hyprland

    echo "setup-host: host activo: $host"
    echo "setup-host: paquetes aplicados: ${packages[*]}"
    echo "setup-host: respaldos: $backup_root"
}

main "$@"
