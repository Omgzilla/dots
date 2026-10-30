#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    printf 'Run this script as your normal desktop user. It asks for sudo access when needed.\n' >&2
    exit 1
fi
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
exec python3 "$source_dir/uninstall_dms_camtoggle.py" "$@"
