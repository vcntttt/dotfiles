#!/bin/bash

# Layout
"$HOME"/.screenlayout/layout.sh

# Keyboard layout
setxkbmap us

# Wallpaper
xwallpaper --maximize ~/git-packages/dotfiles/Wallpapers/32.jpg
picom &

# Keyring
/usr/bin/gnome-keyring-daemon --start --components=ssh,secrets &

# #Polybar
# "$HOME"/.config/polybar/launch.sh

# Load notification service
dunst &

# nm-applet
nm-applet &

#clipmenud
clipmenud &
