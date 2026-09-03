#!/usr/bin/env bash

state="/tmp/wf-recorder.pid"
dir="$HOME/Videos/Screenrecords"

mkdir -p "$dir"

stop_recording() {
    if [ -r "$state" ] && kill -0 "$(cat "$state")" 2>/dev/null; then
        kill -INT "$(cat "$state")" 2>/dev/null
        rm -f "$state"

        if [ -f "$dir/latest.mkv" ]; then
            notify-send -a recorder \
                "Recording stopped" \
                "$dir/latest.mkv"
        else
            notify-send -a recorder "Recording stopped"
        fi

        return 0
    fi

    return 1
}

start_recording() {
    local file="$1"
    shift

    ln -sf -- "$file" "$dir/latest.mkv"

    (
        wf-recorder "$@" -c h264_vaapi -f "$file" &
        echo $! > "$state"
    ) >/dev/null 2>&1 &

    notify-send -a recorder \
        "Recording started" \
        "$file"
}

# Same key stops whichever recording is currently active.
if stop_recording; then
    exit 0
fi

file="$dir/wf-$(date +%F_%H-%M-%S).mkv"

case "${1:-}" in

    region)
        geo="$(slurp)"

        if [ -z "$geo" ]; then
            notify-send -a recorder "Recording canceled"
            exit 0
        fi

        start_recording "$file" -g "$geo"
        ;;

    window)
        rect="$(
            mmsg get all-clients |
                jq -r '.[] | "\(.x),\(.y) \(.width)x\(.height) \(.appid)"' |
                slurp -r
        )"

        if [ -z "$rect" ]; then
            notify-send -a recorder "Recording canceled"
            exit 0
        fi

        start_recording "$file" -g "$rect"
        ;;

    output)
        out="$(slurp -o -f '%o')"

        if [ -z "$out" ]; then
            notify-send -a recorder "Recording canceled"
            exit 0
        fi

        start_recording "$file" -o "$out"
        ;;

    *)
        echo "Usage: $0 {region|window|output}"
        exit 1
        ;;
esac
