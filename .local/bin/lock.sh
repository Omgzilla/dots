#!/bin/sh
# requires scrot imagemagick and i3lock
lockdir="$HOME/.local/share/i3lock-img"

[ -e "$lockdir" ] || mkdir -p $lockdir

scrot -m $lockdir/lock.jpg &&\

convert $lockdir/lock.jpg -blur 0x5 $lockdir/lock-blur.png &&\

i3lock -i $lockdir/lock-blur.png

rm $lockdir/lock.jpg

