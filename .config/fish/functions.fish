# Funciones personales.

# Desactivar el saludo de CachyOS (fastfetch)
function fish_greeting
end

function mkpdf
    set -l file $argv[1]

    if test -z "$file"
        printf 'Uso: mkpdf <ruta-al-tex>\n'
        return 1
    end

    latexmk -pdf "$file"; and latexmk -c "$file"
end

function projector_status
    command -q hyprctl; or return 1
    command -q jq; or return 1

    set -l projector_state (hyprctl -j monitors all 2>/dev/null | jq -r '
    map(select(.name == "HDMI-A-1"))
    | if length == 0 then "disconnected"
      elif .[0].disabled then "disabled"
      elif .[0].mirrorOf == "eDP-1" then "mirror"
      else "extended"
      end
  ')

    printf '%s\n' "$projector_state"
end

function projector_off
    hyprctl keyword workspace '6, monitor:eDP-1' >/dev/null
    hyprctl keyword workspace '7, monitor:eDP-1' >/dev/null
    hyprctl keyword monitor 'HDMI-A-1, disable'
    command pkill -RTMIN+8 waybar >/dev/null 2>&1; or true
end

function mirror
    set -l projector_state (projector_status); or begin
        printf 'No pude consultar Hyprland o jq.\n'
        return 1
    end

    if test "$projector_state" = disconnected
        printf 'No detecto el proyector en HDMI-A-1.\n'
        return 1
    end

    if test "$projector_state" = mirror
        projector_off
        return
    end

    hyprctl keyword monitor 'HDMI-A-1, disable' >/dev/null 2>&1; or true
    hyprctl keyword workspace '6, monitor:eDP-1' >/dev/null
    hyprctl keyword workspace '7, monitor:eDP-1' >/dev/null
    hyprctl keyword monitor 'HDMI-A-1, preferred, auto, 1, mirror, eDP-1'
    command pkill -RTMIN+8 waybar >/dev/null 2>&1; or true
end

function projector
    set -l projector_state (projector_status); or begin
        printf 'No pude consultar Hyprland o jq.\n'
        return 1
    end

    if test "$projector_state" = disconnected
        printf 'No detecto el proyector en HDMI-A-1.\n'
        return 1
    end

    if test "$projector_state" = extended
        projector_off
        return
    end

    hyprctl keyword monitor 'HDMI-A-1, disable' >/dev/null 2>&1; or true
    hyprctl keyword monitor 'HDMI-A-1, preferred, auto-right, 1' >/dev/null
    hyprctl keyword workspace '6, monitor:HDMI-A-1' >/dev/null
    hyprctl keyword workspace '7, monitor:HDMI-A-1' >/dev/null
    command pkill -RTMIN+8 waybar >/dev/null 2>&1; or true
end

function tm
    set -l session $argv[1]
    tmux attach -t "$session"; or tmux new -s "$session"
end

function tc
    if test (count $argv) -ne 1
        printf 'Uso: tc <proyecto>\n'
        return 1
    end

    set -l session $argv[1]
    z "$session"; and tm "$session"
end

function scphl
    command scp $argv 'vrivera@caburgua.tailf8b14c.ts.net:/home/vrivera'
end

function booksend
    if test (count $argv) -eq 0
        printf 'Uso: booksend <archivo...>\n'
        return 1
    end

    if test -d /srv/data/apps/calibre-web/ingest
        command cp -iv $argv /srv/data/apps/calibre-web/ingest/
    else
        command scp $argv 'vrivera@caburgua.tailf8b14c.ts.net:/srv/data/apps/calibre-web/ingest/'
    end
end
