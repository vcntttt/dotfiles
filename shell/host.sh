#!/usr/bin/env bash

DOTFILES_ROOT="${DOTFILES:-$HOME/dotfiles}"
DOTFILES_HOST_FILE="${DOTFILES_HOST_FILE:-$HOME/.config/dotfiles/host}"
DOTFILES_HOST_VALUES="desktop, notebook, caburgua"

read_dotfiles_host() {
    local host_value="${DOTFILES_HOST:-}"

    if [[ -z "$host_value" && -f "$DOTFILES_HOST_FILE" ]]; then
        IFS= read -r host_value < "$DOTFILES_HOST_FILE"
    fi

    host_value="${host_value//$'\n'/}"
    host_value="${host_value//$'\r'/}"
    host_value="${host_value//$'\t'/}"
    host_value="${host_value// /}"

    case "$host_value" in
        desktop|notebook|caburgua)
            printf '%s\n' "$host_value"
            ;;
        *)
            return 1
            ;;
    esac
}

load_dotfiles_host() {
    local host_value

    if ! host_value="$(read_dotfiles_host)"; then
        echo "Dotfiles: host invalido o ausente en $DOTFILES_HOST_FILE. Valores: $DOTFILES_HOST_VALUES" >&2
        return 1
    fi

    export DOTFILES_HOST="$host_value"
}
