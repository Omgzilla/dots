#!/usr/bin/env bash

# Print CPU temperature, GPU usage, and GPU temperature as pipe-separated
# integers. An unavailable metric is represented by -1.
cpu_temp=-1
gpu_usage=-1
gpu_temp=-1

for hwmon in /sys/class/hwmon/hwmon*; do
    [ -r "$hwmon/name" ] || continue
    read -r hwmon_name < "$hwmon/name"
    case "$hwmon_name" in
        coretemp|k10temp|zenpower|cpu_thermal)
            preferred_input=""
            for label in "$hwmon"/temp*_label; do
                [ -r "$label" ] || continue
                read -r label_text < "$label"
                case "$label_text" in
                    "Package id 0"|"Tctl"|"Tdie")
                        preferred_input="${label%_label}_input"
                        break
                        ;;
                esac
            done
            if [ -z "$preferred_input" ]; then
                for input in "$hwmon"/temp*_input; do
                    [ -r "$input" ] || continue
                    preferred_input="$input"
                    break
                done
            fi
            if [ -n "$preferred_input" ] && [ -r "$preferred_input" ]; then
                read -r raw_temp < "$preferred_input"
                case "$raw_temp" in
                    ''|*[!0-9-]*) ;;
                    *) cpu_temp=$((raw_temp / 1000)) ;;
                esac
            fi
            break
            ;;
    esac
done

if command -v nvidia-smi >/dev/null 2>&1; then
    if nvidia_output="$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits 2>/dev/null)"; then
        nvidia_values="${nvidia_output%%$'\n'*}"
        gpu_usage="${nvidia_values%%,*}"
        gpu_temp="${nvidia_values#*,}"
        gpu_usage="${gpu_usage//[[:space:]]/}"
        gpu_temp="${gpu_temp//[[:space:]]/}"
    fi
fi

if [ "$gpu_usage" = -1 ]; then
    for busy in /sys/class/drm/card*/device/gpu_busy_percent /sys/class/drm/card*/device/gt_busy_percent; do
        [ -r "$busy" ] || continue
        read -r raw_usage < "$busy"
        case "$raw_usage" in
            ''|*[!0-9]*) ;;
            *) gpu_usage="$raw_usage"; break ;;
        esac
    done
fi

if [ "$gpu_temp" = -1 ]; then
    for input in /sys/class/drm/card*/device/hwmon/hwmon*/temp1_input; do
        [ -r "$input" ] || continue
        read -r raw_temp < "$input"
        case "$raw_temp" in
            ''|*[!0-9-]*) ;;
            *) gpu_temp=$((raw_temp / 1000)); break ;;
        esac
    done
fi

printf '%s|%s|%s\n' "$cpu_temp" "$gpu_usage" "$gpu_temp"
