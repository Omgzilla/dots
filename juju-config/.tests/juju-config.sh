#!/usr/bin/env bash
set -euo pipefail

package=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
bin=$package/.local/bin
runner=$bin/set-juju-config
preset=$bin/set-juju-config-preset
for script in "$runner" "$preset"; do
  bash -n "$script"
done
if command -v shellcheck >/dev/null; then
  shellcheck "$runner" "$preset"
else
  echo 'ShellCheck not installed; skipping it.' >&2
fi

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
export SET_JUJU_CONFIG_PRESETS=$tmp/presets.json
export JUJU_LOG=$tmp/juju.log
export JUJU_WRITE_MODE=deny
: > "$JUJU_LOG"
cat > "$SET_JUJU_CONFIG_PRESETS" <<'EOF'
{
  "defaults": {
    "settings": {"default-base": "ubuntu@24.04", "apt-http-proxy": ""},
    "exclude_model_settings": {"admin/lxd-hosts": ["apt-http-proxy"]}
  },
  "presets": {
    "standard": {
      "controller": "lab",
      "exclude_clouds": ["other"],
      "exclude_models": ["admin/exempt"],
      "settings": {"extra-info": "env=test,owner=ops"}
    }
  }
}
EOF

juju() {
  printf '%s\n' "$*" >> "$JUJU_LOG"
  case $1 in
    clouds) printf '%s\n' '{"lab-cloud":{},"other":{}}' ;;
    models) printf '%s\n' '{"models":[{"name":"admin/controller"},{"name":"admin/alternate-controller","is-controller":true},{"name":"admin/lxd-hosts","cloud":"lab-cloud"},{"name":"admin/exempt","cloud":"lab-cloud"},{"name":"admin/workload","cloud":"lab-cloud"},{"name":"admin/later","cloud":"lab-cloud"},{"name":"admin/elsewhere","cloud":"other"}]}' ;;
    model-defaults|model-config)
      [[ $JUJU_WRITE_MODE == fail ]] || return 99
      if [[ $1 == model-config && $3 == lab:admin/workload ]]; then return 7; fi
      ;;
    *) return 99 ;;
  esac
}
export -f juju

contains() {
  [[ $1 == *"$2"* ]] || { printf 'Missing %s in:\n%s\n' "$2" "$1" >&2; exit 1; }
}
absent() {
  [[ $1 != *"$2"* ]] || { printf 'Unexpected %s in:\n%s\n' "$2" "$1" >&2; exit 1; }
}

out=$("$preset" --list)
contains "$out" $'standard\tlab\t'
out=$("$preset" --check)
contains "$out" 'Valid preset configuration (all)'
[[ ! -s $JUJU_LOG ]]

jq '.presets.standard.exclude_cloud = ["other"]' "$SET_JUJU_CONFIG_PRESETS" > "$tmp/invalid.json"
status=0
out=$(SET_JUJU_CONFIG_PRESETS="$tmp/invalid.json" "$preset" --check 2>&1) || status=$?
[[ $status != 0 && ! -s $JUJU_LOG ]]
contains "$out" 'unknown fields: exclude_cloud'

out=$("$preset" standard 2>&1)
contains "$out" 'Preview on lab: 1 cloud default update(s), 3 model update(s); 1 model(s) with some settings excluded.'
contains "$out" '2 controller model(s), 1 excluded model(s)'
contains "$out" 'Leaving settings unchanged on admin/lxd-hosts: apt-http-proxy'
contains "$out" 'extra-info=env=test\,owner=ops'
line=$(grep -F 'model-config --model lab:admin/lxd-hosts' <<< "$out")
contains "$line" 'default-base=ubuntu@24.04'
absent "$line" 'apt-http-proxy='
absent "$out" '--model lab:admin/controller'
absent "$out" '--model lab:admin/exempt'
absent "$out" '--cloud other'
absent "$(< "$JUJU_LOG")" 'model-config'
absent "$(< "$JUJU_LOG")" 'model-defaults'

: > "$JUJU_LOG"
export JUJU_WRITE_MODE=fail
status=0
out=$("$preset" --apply standard 2>&1) || status=$?
[[ $status == 7 ]]
contains "$out" 'Stopped on lab (model: admin/workload): Juju exited 7 after 2 successful update(s) in this run.'
absent "$(< "$JUJU_LOG")" 'admin/later'
printf '%s\n' 'Juju config tests passed.'
