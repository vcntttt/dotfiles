copyfile() {
  if [ -f "$1" ]; then
    local rel_path
    rel_path=$(realpath --relative-to="$PWD" "$1" 2>/dev/null) || rel_path="$1"
    (echo "Ruta del archivo: ${rel_path}" && echo "" && cat "$1") | xclip -selection clipboard
    echo "Contenido de '$1' copiado al portapapeles."
  else
    echo "Error: El archivo '$1' no existe."
  fi
}
alias cpn='copyfile'

alias tgz='comprimir'
_comprimir() {
  local dir_name=$(basename "$1")
  tar -czvf "$dir_name".tar.gz "$1"
}

ghiFunction() {
  git init && gh repo create "$1" --public --source=. --remote=origin
}
alias ghinit=ghiFunction

brilloFunction() {
  if [ "$1" -eq 0 ]; then
    xrandr --output DP-0 --brightness "$2"
  elif [ "$1" -eq 1 ]; then
    xrandr --output HDMI-1 --brightness "$2"
  else
    xrandr --output DP-0 --brightness "$2"
    xrandr --output HDMI-1 --brightness "$2"
  fi
}
alias brillodk=brilloFunction
