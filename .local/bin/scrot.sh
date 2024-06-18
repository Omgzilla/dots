#!/bin/bash
date=$(date +"%Y-%m-%d_%H-%M-%S")
output="/home/marcus/Pictures/Screenshots/scrot-$date.png"

case "$1" in
  "select") scrot "$output" --select --line mode=edge || exit;;
  "window") scrot "$output" --focused --border || exit;;
  *) scrot "$output" || exit;;
esac

notify-send "Screenshot taken! ($output)"

