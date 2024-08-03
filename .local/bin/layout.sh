#!/bin/sh
xrandr \
 --output DP-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --rate 165 \
 --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal --rate 144 \
 --output DP-1 --off \
 --output HDMI-0 --off \
 --output DVI-D-0 --off
