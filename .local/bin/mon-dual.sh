#!/bin/sh
xrandr --output eDP-1 --off --output HDMI-1 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-3-1 --off --output DP-3-2 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP-3-3 --mode 2560x1440 --pos 2560x0 --rotate normal
sleep 1
bash /home/marcus/.local/bin/xwp
