# Perfil de shell para el notebook CachyOS.
source "$HOME/.config/fish/cachyos.fish"

set -g DOTFILES_NOTEBOOK_INTERNAL_MONITOR eDP-1
set -g DOTFILES_NOTEBOOK_EXTERNAL_MONITOR HDMI-A-1

function projector_status
    command -q hyprctl; or return 1
    command -q jq; or return 1

    set -l internal "$DOTFILES_NOTEBOOK_INTERNAL_MONITOR"
    set -l external "$DOTFILES_NOTEBOOK_EXTERNAL_MONITOR"

    hyprctl -j monitors all 2>/dev/null | jq -r --arg internal "$internal" --arg external "$external" '
        map(select(.name == $external))
        | if length == 0 then "disconnected"
          elif .[0].disabled then "disabled"
          elif .[0].mirrorOf == $internal then "mirror"
          else "extended"
          end
    '
end

function projector_off
    set -l internal "$DOTFILES_NOTEBOOK_INTERNAL_MONITOR"
    set -l external "$DOTFILES_NOTEBOOK_EXTERNAL_MONITOR"

    hyprctl keyword workspace "6, monitor:$internal" >/dev/null
    hyprctl keyword workspace "7, monitor:$internal" >/dev/null
    hyprctl keyword monitor "$external, disable" >/dev/null
    command noctalia msg config-reload >/dev/null 2>&1; or true
end

function mirror
    set -l projector_state (projector_status); or begin
        printf 'No pude consultar Hyprland o jq.\n'
        return 1
    end

    if test "$projector_state" = disconnected
        printf 'No detecto el monitor externo en %s.\n' "$DOTFILES_NOTEBOOK_EXTERNAL_MONITOR"
        return 1
    end

    if test "$projector_state" = mirror
        projector_off
        return
    end

    set -l internal "$DOTFILES_NOTEBOOK_INTERNAL_MONITOR"
    set -l external "$DOTFILES_NOTEBOOK_EXTERNAL_MONITOR"
    hyprctl keyword monitor "$external, disable" >/dev/null 2>&1; or true
    hyprctl keyword workspace "6, monitor:$internal" >/dev/null
    hyprctl keyword workspace "7, monitor:$internal" >/dev/null
    hyprctl keyword monitor "$external, preferred, auto, 1, mirror, $internal" >/dev/null
    command noctalia msg config-reload >/dev/null 2>&1; or true
end

function projector
    set -l projector_state (projector_status); or begin
        printf 'No pude consultar Hyprland o jq.\n'
        return 1
    end

    if test "$projector_state" = disconnected
        printf 'No detecto el monitor externo en %s.\n' "$DOTFILES_NOTEBOOK_EXTERNAL_MONITOR"
        return 1
    end

    if test "$projector_state" = extended
        projector_off
        return
    end

    set -l external "$DOTFILES_NOTEBOOK_EXTERNAL_MONITOR"
    hyprctl keyword monitor "$external, disable" >/dev/null 2>&1; or true
    hyprctl keyword monitor "$external, preferred, auto-right, 1" >/dev/null
    hyprctl keyword workspace "6, monitor:$external" >/dev/null
    hyprctl keyword workspace "7, monitor:$external" >/dev/null
    command noctalia msg config-reload >/dev/null 2>&1; or true
end

abbr --add extend projector
