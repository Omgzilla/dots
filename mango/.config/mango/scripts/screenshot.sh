#!/usr/bin/env bash

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

name="screenshot-$(date +%Y%m%d-%H%M%S).png"
path="$dir/$name"
latest="$dir/latest.png"

save_screenshot() {
    if "$@"; then
        ln -sfn -- "$path" "$latest"

        # Immediately copy original screenshot
        wl-copy --type image/png < "$path"

        action="$(
            notify-send \
                -a Screenshot \
                -i "$path" \
                --action=default="Edit" \
                "Screenshot saved" \
                "Copied to clipboard"
        )"

        if [ "$action" = "default" ]; then
            satty \
                --filename "$path" \
                --output-filename "$path" \
                --copy-command wl-copy

            # If Satty saved changes to the file,
            # update clipboard with the edited version.
            if [ -f "$path" ]; then
                wl-copy --type image/png < "$path"
            fi
        fi
    else
        rm -f "$path"
        exit 1
    fi
}

case "${1:-}" in

    region)
        geo="$(slurp)"

        if [ -z "$geo" ]; then
            notify-send -a Screenshot "Screenshot canceled"
            exit 0
        fi

        save_screenshot grim -g "$geo" "$path"
        ;;

    window)
        geo="$(
            mmsg get all-clients |
                jq -r '.[] | "\(.x),\(.y) \(.width)x\(.height) \(.appid)"' |
                slurp -r
        )"

        if [ -z "$geo" ]; then
            notify-send -a Screenshot "Screenshot canceled"
            exit 0
        fi

        save_screenshot grim -g "$geo" "$path"
        ;;

    output)
        out="$(slurp -o -f '%o')"

        if [ -z "$out" ]; then
            notify-send -a Screenshot "Screenshot canceled"
            exit 0
        fi

        save_screenshot grim -o "$out" "$path"
        ;;

    *)
        echo "Usage: $0 {region|window|output}"
        exit 1
        ;;
esac
