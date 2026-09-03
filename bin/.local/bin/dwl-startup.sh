#!/bin/bash

# Kill already running dublicate process
_ps="waybar mako swaybg"
for _prs in $_ps; do
    if [ "$(pidof "${_prs}")" ]; then
         killall -9 "${_prs}"
    fi
 done

# Start our applications
#swaybg --output '*' --mode center  --image /path-to-your-favorite-wallpaper &
mako &
waybar -c ~/versioned/omgzilla/dwl/waybar/config.jsonc -s ~/versioned/omgzilla/dwl/waybar/style.css &
#foot --server &
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
