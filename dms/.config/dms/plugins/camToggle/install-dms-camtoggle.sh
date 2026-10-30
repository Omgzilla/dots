#!/usr/bin/env bash
set -euo pipefail

source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
plugin_dir="${XDG_CONFIG_HOME:-$HOME/.config}/dms/plugins"
destination="$plugin_dir/camToggle"

python3 - "$source_dir" "$destination" <<'PY'
from pathlib import Path
import os
import shutil
import sys
import tempfile

source, destination = (Path(argument) for argument in sys.argv[1:])
marker = ".dms-camtoggle-install"
files = (
    "plugin.json", "CamToggle.qml", "CamToggleSettings.qml", "CamToggleMonitor.qml",
    "cam_toggle.py", "cam_toggle_helper.py", "README.md", "install-dms-camtoggle.sh",
    "install-dms-camtoggle-system.sh", "org.dms.camtoggle.policy", "70-dms-camtoggle.rules",
    "uninstall-dms-camtoggle.sh", "uninstall_dms_camtoggle.py",
    "00-dms-camtoggle-admin.rules.in",
)
for name in files:
    if not (source / name).is_file():
        sys.exit("Missing plugin file: " + name)

if destination.is_symlink():
    if destination.exists() and destination.resolve() != source:
        sys.exit("Refusing to replace a symlink to another existing plugin: " + str(destination))
elif destination.exists():
    if destination.resolve() == source:
        print("Already running from the installed plugin: " + str(destination))
        sys.exit(0)
    if not destination.is_dir() or not (destination / marker).is_file():
        sys.exit("Refusing to replace an unmanaged plugin directory: " + str(destination))

destination.parent.mkdir(parents=True, exist_ok=True)
# DMS 2.0 can remain in settings discovery when config.d is absent.
# An empty directory lets its folder watcher finish without changing settings.
(destination.parent.parent / "config.d").mkdir(exist_ok=True)
staging = Path(tempfile.mkdtemp(prefix=".camToggle-install-", dir=destination.parent))
backup = None
try:
    for name in files:
        target = staging / name
        shutil.copyfile(source / name, target)
        target.chmod(0o755 if name.endswith(".sh") else 0o644)
    (staging / marker).write_text("Managed by install-dms-camtoggle.sh\n")
    if os.path.lexists(destination):
        backup = Path(tempfile.mkdtemp(prefix=".camToggle-backup-", dir=destination.parent))
        backup.rmdir()
        destination.rename(backup)
    try:
        staging.rename(destination)
    except OSError:
        if backup is not None:
            backup.rename(destination)
            backup = None
        raise
    if backup is not None:
        if backup.is_symlink():
            backup.unlink()
        else:
            shutil.rmtree(backup)
    print("Installed Cam Toggle: " + str(destination))
finally:
    if staging.exists():
        shutil.rmtree(staging)
PY

printf 'In DMS Settings > Plugins, scan for plugins and enable Cam Toggle, then add it to your bar or Control Center.\n'
printf 'See README.md to install the system helper. Reboot/reconnect restoration is optional in settings.\n'
