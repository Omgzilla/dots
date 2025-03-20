#!/bin/bash

# Define monitor descriptions and workspace numbers
declare -A WORKSPACE_MAP
WORKSPACE_MAP["Lenovo Group Limited P27q-20 V90AW8MZ"]="1-5"
WORKSPACE_MAP["Lenovo Group Limited P27q-20 V90AW8YD"]="6-10"
WORKSPACE_MAP["Samsung Electric Company S27B80T HCJX100493"]="1-5"
WORKSPACE_MAP["Acer Technologies XB271HU A T4TEE0068505"]="1-5"

# Get the list of connected monitors
MONITORS=$(hyprctl monitors -j | jq -r '.[] | "\(.description) \(.name)"')

# Loop through each monitor and assign workspaces
while read -r DESCRIPTION DP_ID; do
    if [[ -n "${WORKSPACE_MAP[$DESCRIPTION]}" ]]; then
        # Assign workspaces to this DP ID
        for WS in ${WORKSPACE_MAP[$DESCRIPTION]}; do
            hyprctl dispatch workspace $WS
            hyprctl keyword workspace "$WS, monitor:$DP_ID"
        done
    fi
done <<< "$MONITORS"

echo "Workspaces assigned based on connected monitors."

