#!/bin/bash

# Layout
"$HOME"/.local/bin/layout.sh &

# Keyboard layout
setxkbmap us &

# Wallpapers
WALLPAPER_CONFIG1="$HOME/.config/qtile/scripts/wallpaper1"
WALLPAPER_CONFIG2="$HOME/.config/qtile/scripts/wallpaper2"
DEFAULT_WALLPAPER="$HOME/Pictures/Wallpapers/spiderverse3.jpg"

# Primer Monitor
if [ -f "$WALLPAPER_CONFIG1" ]; then
    xwallpaper --output DP-0 --maximize "$(cat "$WALLPAPER_CONFIG1")"
else
    xwallpaper --output DP-0 --maximize "$DEFAULT_WALLPAPER"
fi

# Segundo Monitor
if [ -f "$WALLPAPER_CONFIG2" ]; then
    xwallpaper --output HDMI-1 --maximize "$(cat "$WALLPAPER_CONFIG2")"
else
    xwallpaper --output HDMI-1 --maximize "$DEFAULT_WALLPAPER"
fi

# compositor
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

# sync
dropbox &

brave &
python $HOME/dev/tmo-bot/main.py &
# discord --start-minimized &
openrgb --profile "/home/vrivera/.config/OpenRGB/todo-celeste.orp" &
