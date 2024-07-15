#!/bin/bash
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
		pkill -u $USER dwm
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



