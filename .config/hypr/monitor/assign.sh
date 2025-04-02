#!/bin/bash

# Define monitor descriptions and workspace ranges
declare -A WORKSPACE_MAP
WORKSPACE_MAP["Lenovo Group Limited P27q-20 V90AW8MZ"]="1-5"
WORKSPACE_MAP["Lenovo Group Limited P27q-20 V90AW8YD"]="6-10"
WORKSPACE_MAP["Samsung Electric Company S27B80T HCJX100493"]="1-5"
WORKSPACE_MAP["Acer Technologies XB271HU A T4TEE0068505"]="6-10"

# Get connected monitors: description and ID
MONITORS=$(hyprctl monitors -j | jq -r '.[] | "\(.description)|\(.name)"')

# Loop through each monitor
while IFS="|" read -r DESCRIPTION DP_ID; do
    RANGE="${WORKSPACE_MAP[$DESCRIPTION]}"
    if [[ -n "$RANGE" ]]; then
        # Expand range like "1-5" into "1 2 3 4 5"
        IFS="-" read -r START END <<< "$RANGE"
        for (( WS=START; WS<=END; WS++ )); do
            echo "Assigning workspace $WS to $DP_ID ($DESCRIPTION)"
            hyprctl dispatch workspace "$WS"
            hyprctl keyword workspace "$WS, monitor:$DP_ID"
        done
    else
        echo "No workspace mapping found for monitor: $DESCRIPTION"
    fi
done <<< "$MONITORS"

echo "✅ Workspaces assigned based on connected monitors."

