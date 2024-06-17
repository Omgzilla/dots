#!/bin/bash

 grep XK_ ~/.local/suckless/dwm/config.h | \
     grep -v TAGKEYS | \
     sed -e 's/^[ \t]*//' \
     -e 's/[}{]//g' \
     -e 's/,//g' \
     -e 's/XK_//g' \
     -e 's/[)(]//g' \
     -e 's/[][]//g' \
     -e 's/SHCMD//g' \
     -e 's/["]//g' \
     -e 's/MODKEY/Super/g' \
     -e 's/|ShiftMask/-Shift/g' \
     -e 's/ALTKEY/Alt/g' | \
     awk '{print $1 "-" $2 " "  $3 $4 $5 $6 $7 $8 }' | \
     sed -e 's/^0-//g' \
     -e 's/0$//g' | \
     column -t | \
     yad --text-info --back=#1d1f21 --fore=#c5c8c6 --geometry=550x720 --center

