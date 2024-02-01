#!/bin/bash

# Layout
"$HOME"/.local/.bin/layout.sh

# Keyboard layout
setxkbmap us

# Wallpaper
WALLPAPER_CONFIG="$HOME/.config/qtile/scripts/wallpaper"
if [ -f "$WALLPAPER_CONFIG" ]; then
    xwallpaper --maximize "$(cat "$WALLPAPER_CONFIG")"
else
    xwallpaper --maximize ~/git-packages/dots-assets//Wallpapers/32.jpg
fi
picom &

# Keyring
/usr/bin/gnome-keyring-daemon --start --components=ssh,secrets &

# Load notification service
dunst &

# systray
nm-applet &
volumeicon &
udiskie -t &

# herramientas
greenclip daemon &
flameshot &

# comunication
mailspring --b --password-store="gnome-libsecret" &
discord --start-minimized &

# sync
dropbox &
$HOME/.local/bin/sync &
