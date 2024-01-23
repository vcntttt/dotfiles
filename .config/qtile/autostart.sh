#!/bin/bash

# Layout
"$HOME"/.screenlayout/layout.sh

# Keyboard layout
setxkbmap us

# Wallpaper
WALLPAPER_CONFIG="$HOME/.config/qtile/scripts/wallpaper"
if [ -f "$WALLPAPER_CONFIG" ]; then
    xwallpaper --maximize "$(cat "$WALLPAPER_CONFIG")"
else
    xwallpaper --maximize ~/git-packages/dotfiles/Wallpapers/32.jpg
fi
picom &

# Keyring
/usr/bin/gnome-keyring-daemon --start --components=ssh,secrets &

# Load notification service
dunst &

# nm-applet
nm-applet &

#clipmenud
#clipmenud &

#ss
flameshot &

#brillo de los monitores
brightness-controller &

# comunication
mailspring --b --password-store="gnome-libsecret" &
discord --start-minimized &
