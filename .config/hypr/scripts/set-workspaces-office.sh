#!/bin/bash
# Wait for monitors to settle
sleep 1
hyprctl reload
hyprctl dispatch exec "source ~/.config/hypr/monitor/office.conf"

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

move_workspace_to 1 "Lenovo Group Limited P27q-20 V90AW8MZ"
move_workspace_to 2 "Lenovo Group Limited P27q-20 V90AW8MZ"
move_workspace_to 3 "Lenovo Group Limited P27q-20 V90AW8MZ"
move_workspace_to 4 "Lenovo Group Limited P27q-20 V90AW8MZ"
move_workspace_to 5 "Lenovo Group Limited P27q-20 V90AW8MZ"
move_workspace_to 6 "Lenovo Group Limited P27q-20 V90AW8YD"
move_workspace_to 7 "Lenovo Group Limited P27q-20 V90AW8YD"
move_workspace_to 8 "Lenovo Group Limited P27q-20 V90AW8YD"
move_workspace_to 9 "Lenovo Group Limited P27q-20 V90AW8YD"
move_workspace_to 10 "Lenovo Group Limited P27q-20 V90AW8YD"
