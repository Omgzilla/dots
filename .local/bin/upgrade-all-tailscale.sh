#!/bin/bash

containers=(
"site-lab:juju-b5f8f7-1"
"site-lab:juju-b5f8f7-2"
"site-lab:juju-b5f8f7-3"
"lagos1:tailscale"
"lagos2:tailscale"
"tunis1:tailscale"
"tunis2:tailscale"
"dwellir2:tailscale"
"dwellir1:tailscale"
"dwellir4:tailscale"
"dwellir5:tailscale"
"dwellir6:tailscale"
"dwellir8:tailscale"
"dwellir7:tailscale"
)

echo "Start upgrading tailscale clients"
echo ""
for tailscale in "${containers[@]}"; do
  echo "Upgrading tailscale on $tailscale"
  echo ""
  lxc exec $tailscale -- sh -c "sudo apt update && sudo apt upgrade -y"
done

echo ""
echo "All tailscale clients is upgraded"
echo "exiting script..."
