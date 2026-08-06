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
