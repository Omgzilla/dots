#!/bin/bash
# Path containing repos
base="$HOME/versioned/dwellir-public"

# Dwellir repos to update
repositories=(
  "blockchain-monitor-operator"
  "dwellir-dns"
  "ipmi-exporter-operator"
  "observability-configuration"
  "ops"
  "polkadot-operator"
  "rpc-endpoint-db-operator"
)

for repo in "${repositories[@]}"
do
  echo "> Updating $repo"
  cd "$base/$repo"
  git fetch --all --prune --jobs=10
  git checkout main
  git rebase origin/main
done
