#!/bin/bash
# Wait for monitors to settle
sleep 1
hyprctl reload
hyprctl dispatch exec "source ~/.config/hypr/monitor/default.conf"

hyprctl dispatch moveworkspacetomonitor 1 eDP-1
hyprctl dispatch moveworkspacetomonitor 2 eDP-1
hyprctl dispatch moveworkspacetomonitor 3 eDP-1
hyprctl dispatch moveworkspacetomonitor 4 eDP-1
hyprctl dispatch moveworkspacetomonitor 5 eDP-1
hyprctl dispatch moveworkspacetomonitor 6 eDP-1
hyprctl dispatch moveworkspacetomonitor 7 eDP-1
hyprctl dispatch moveworkspacetomonitor 8 eDP-1
hyprctl dispatch moveworkspacetomonitor 9 eDP-1
hyprctl dispatch moveworkspacetomonitor 10 eDP-1
hyprctl dispatch workspace 1

