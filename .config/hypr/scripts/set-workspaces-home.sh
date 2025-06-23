#!/bin/bash
# Wait for monitors to settle
sleep 1
hyprctl reload
hyprctl dispatch exec "source ~/.config/hypr/monitor/home.conf"

get_connector_from_edid_name() {
  local edid_name="$1"
  hyprctl monitors -j | jq -r --arg name "$edid_name" '.[] | select(.description == $name) | .name'
}

# Map EDID names to stable workspace assignments
move_workspace_to() {
  local workspace="$1"
  local edid_name="$2"
  local conn
  conn=$(get_connector_from_edid_name "$edid_name")
  if [ -n "$conn" ]; then
    echo "Moving workspace $workspace to $conn"
    hyprctl dispatch moveworkspacetomonitor "$workspace" "$conn"
  else
    echo "Monitor $edid_name not found, skipping workspace $workspace"
  fi
}

move_workspace_to 1 eDP-1
move_workspace_to 2 eDP-1
move_workspace_to 3 eDP-1
move_workspace_to 4 eDP-1
move_workspace_to 5 eDP-1
move_workspace_to 6 "Acer Technologies XB271HU A T4TEE0068505"
move_workspace_to 7 "Acer Technologies XB271HU A T4TEE0068505"
move_workspace_to 8 "Acer Technologies XB271HU A T4TEE0068505"
move_workspace_to 9 "Acer Technologies XB271HU A T4TEE0068505"
move_workspace_to 10 "Acer Technologies XB271HU A T4TEE0068505"
