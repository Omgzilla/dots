#!/bin/bash
#
#wm () {
#    local window=$(
#        xprop -root -notype
#    )
#
#    local identifier=$(
#        echo "${window}" |
#        awk '$1=="_NET_SUPPORTING_WM_CHECK:"{print $5}'
#    )
#
#    local attributes=$(
#        xprop -id "${identifier}" -notype -f _NET_WM_NAME 8t
#    )
#
#    local name=$(
#        echo "${attributes}" |
#        grep "_NET_WM_NAME = " |
#        cut --delimiter=' ' --fields=3 |
#        cut --delimiter='"' --fields=2
#    )
#
#    echo "${name}"
#}
#wmpid="$(pidof $(wm))"

menu=("󰌾 lock
󰜉 restart-wm
󰍃 logout
󰤁 reboot
󰐥 shutdown")

choice="$(echo -e "${menu[@]}" | dmenu -l 5 -p "󰩈 Exit: ")"
[ -z "$choice" ] && exit 0
case "$choice" in
	󰌾*)
		lock.sh
		;;
  󰜉*)
		pkill dwm
		;;
	󰍃*)
		loginctl terminate-user $USER	
		;;
	󰤁*)
		reboot
		;;
	󰐥*)
		poweroff
		;;
	*)
		exit 1
		;;
esac



