#!/usr/bin/env bash

set -u

monitors_json="$(mmsg get all-monitors 2>/dev/null)" || exit 1
current_json='{"outputs":[]}'
if command -v dms >/dev/null 2>&1; then
    current_json="$(dms randr --json 2>/dev/null)" || current_json='{"outputs":[]}'
fi

while IFS=$'\t' read -r name width height scale x y active; do
    refresh="$(printf '%s' "$current_json" | jq -r --arg name "$name" '.outputs[]? | select(.name == $name) | (.refresh / 1000)' | head -n 1)"
    if [[ -z "$refresh" || "$refresh" == "null" ]]; then
        refresh=0
    fi
    printf 'OUTPUT\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$name" "$width" "$height" "$refresh" "$scale" "$x" "$y" "$active"

    edid_path=""
    for candidate in /sys/class/drm/card*-"$name"/edid; do
        if [[ -r "$candidate" ]]; then
            edid_path="$candidate"
            break
        fi
    done

    if [[ -n "$edid_path" ]] && command -v edid-decode >/dev/null 2>&1; then
        edid-decode "$edid_path" 2>/dev/null | awk -v output="$name" '
            /DMT 0x|DTD [0-9]+:/ {
                resolution = ""; rate = ""
                for (i = 1; i <= NF; i++) {
                    if ($i ~ /^[0-9]+x[0-9]+$/) resolution = $i
                    if ($i == "Hz" && i > 1) rate = $(i - 1)
                }
                if (resolution != "" && rate != "") {
                    split(resolution, dimensions, "x")
                    printf "MODE\t%s\t%s\t%s\t%.3f\n", output, dimensions[1], dimensions[2], rate
                }
            }
        '
    fi

    if [[ "$refresh" != "0" ]]; then
        printf 'MODE\t%s\t%s\t%s\t%.3f\n' "$name" "$width" "$height" "$refresh"
    fi
done < <(printf '%s' "$monitors_json" | jq -r '.monitors[] | [.name, .width, .height, .scale, .x, .y, .active] | @tsv')
