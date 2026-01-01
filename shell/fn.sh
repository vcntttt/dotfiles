# comprimir archivo
tgz() {
  local dir_name=$(basename "$1")
  tar -czvf "$dir_name".tar.gz "$1"
}

# GitHub repo initializer
ghi() {
  git init && gh repo create "$1" --public --source=. --remote=origin
}

# Adjustar brillo de monitores
bdk() {
  if [ "$1" -eq 0 ]; then
    xrandr --output DP-0 --brightness "$2"
  elif [ "$1" -eq 1 ]; then
    xrandr --output HDMI-1 --brightness "$2"
  else
    xrandr --output DP-0 --brightness "$2"
    xrandr --output HDMI-1 --brightness "$2"
  fi
}
