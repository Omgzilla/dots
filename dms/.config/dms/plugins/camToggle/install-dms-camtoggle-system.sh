#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 || $# -ne 1 || ! $1 =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
    printf 'Usage: sudo bash install-dms-camtoggle-system.sh YOUR_USERNAME\n' >&2
    exit 1
fi
id -u -- "$1" >/dev/null
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
command -v visudo >/dev/null
command -v udevadm >/dev/null
command -v pkexec >/dev/null
test -x /usr/bin/python3

# Validate the complete sudoers drop-in before installing any files.
temporary=$(mktemp)
admin_rule=$(mktemp)
trap 'rm -f -- "$temporary" "$admin_rule"' EXIT
printf '%s ALL=(root) NOPASSWD: /usr/local/libexec/dms-camtoggle set *\n' "$1" > "$temporary"
chmod 0600 "$temporary"
visudo -cf "$temporary"
sed "s/@CAMTOGGLE_USER@/$1/g" "$source_dir/00-dms-camtoggle-admin.rules.in" > "$admin_rule"

install -d -o root -g root -m 0755 /usr/local/libexec
install -d -o root -g root -m 0755 /etc/udev/rules.d
if [[ ! -d /etc/polkit-1/rules.d ]]; then
    install -d -o root -g root -m 0755 /etc/polkit-1/rules.d
fi
install -d -o root -g root -m 0700 /var/lib/dms-camtoggle
install -o root -g root -m 0755 "$source_dir/cam_toggle_helper.py" /usr/local/libexec/dms-camtoggle
install -o root -g root -m 0644 "$source_dir/org.dms.camtoggle.policy" /usr/share/polkit-1/actions/org.dms.camtoggle.policy
install -o root -g root -m 0644 "$admin_rule" /etc/polkit-1/rules.d/00-dms-camtoggle-admin.rules
install -o root -g root -m 0440 "$temporary" /etc/sudoers.d/zz-dms-camtoggle
# A user's general PASSWD rule can override an earlier NOPASSWD entry.
# Keep the camera-only exception after ordinary per-user rules.
if [[ -f /etc/udev/rules.d/70-dms-camtoggle.rules ]]; then
    /usr/local/libexec/dms-camtoggle set-restore 1
fi
/usr/local/libexec/dms-camtoggle info
printf 'Installed Cam Toggle helper, camera-toggle sudo rule and administrator authentication policy.\nRestoration is optional: enable it in plugin settings to authenticate and install the udev rule. No cameras were switched.\n'
printf 'Restoration changes authenticate as %s; ordinary camera toggles are passwordless.\n' "$1"
