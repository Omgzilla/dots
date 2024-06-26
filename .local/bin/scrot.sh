#!/bin/bash
date=$(date +"%Y-%m-%d_%H-%M-%S")
output="/home/marcus/Pictures/Screenshots/scrot-$date.png"

case "$1" in
  "select") scrot "$output" --select --line mode=edge && xclip -selection clipboard -t image/png -i $output || exit;;
  "window") scrot "$output" --focused --border && xclip -selection clipboard -t image/png -i $output || exit;;
  *) scrot "$output" && xclip -selection clipboard -t image/png -i $output || exit;;
esac

notify-send "Screenshot taken! ($output)"

