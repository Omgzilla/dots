#!/usr/bin/env python3
"""Fully uninstall Cam Toggle, restoring its cameras before deleting settings."""

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


def is_plugin_id(value):
    return isinstance(value, str) and any(
        value == prefix or value.startswith(prefix + ":")
        for prefix in ("camToggle", "plugin_camToggle", "plugin:camToggle")
    )


def clean_settings(value):
    if isinstance(value, dict):
        return {key: clean_settings(item) for key, item in value.items()
                if not is_plugin_id(key) and not (isinstance(item, str) and is_plugin_id(item))}
    if isinstance(value, list):
        return [clean_settings(item) for item in value
                if not (isinstance(item, str) and is_plugin_id(item))
                and not (isinstance(item, dict) and any(is_plugin_id(item.get(key))
                                                       for key in ("id", "widgetId", "pluginId")))]
    return value


def inspect_user_install(config_home):
    directory = config_home / "dms/plugins/camToggle"
    if directory.is_symlink():
        raise ValueError("Refusing to remove a symlink; the current installer creates a managed plugin directory")
    elif directory.exists() and not (directory / ".dms-camtoggle-install").is_file():
        raise ValueError("Refusing to remove an unmanaged plugin directory: " + str(directory))
    updates = {}
    selected_ids = []
    for name in ("plugin_settings.json", "settings.json", "plugins.lock.json"):
        path = config_home / "dms" / name
        if not path.exists():
            continue
        data = json.loads(path.read_text())
        if not isinstance(data, dict):
            raise ValueError("Expected a settings object in " + str(path))
        if name == "plugin_settings.json":
            selected_ids = data.get("camToggle", {}).get("selectedDeviceIds", [])
            if not isinstance(selected_ids, list) or any(not isinstance(key, str) for key in selected_ids):
                raise ValueError("Invalid selected camera IDs in " + str(path))
        cleaned = clean_settings(data)
        if cleaned != data:
            updates[path] = cleaned
    return directory, updates, selected_ids


def save_settings(path, settings):
    # Preserve a dotfile symlink if the settings file itself is linked.
    destination = path.resolve()
    fd, temporary = tempfile.mkstemp(prefix=".dms-camtoggle-cleanup-", dir=destination.parent)
    try:
        with os.fdopen(fd, "w") as stream:
            os.fchmod(stream.fileno(), destination.stat().st_mode & 0o777)
            json.dump(settings, stream, indent=4)
            stream.write("\n")
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, destination)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def remove_user_install(config_home, state_home):
    directory, updates, _ = inspect_user_install(config_home)
    if directory.exists():
        shutil.rmtree(directory)
    for path, data in updates.items():
        save_settings(path, data)
    state_directory = state_home / "dms/plugins"
    if state_directory.exists():
        for path in state_directory.iterdir():
            if path.name.endswith("_state.json") and is_plugin_id(path.name[:-11]):
                path.unlink()


def main():
    argparse.ArgumentParser(description=__doc__).parse_args()
    if os.geteuid() == 0:
        sys.exit("Run the uninstaller as your normal desktop user; it requests sudo access itself.")
    config_home = Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config")
    state_home = Path(os.environ.get("XDG_STATE_HOME") or Path.home() / ".local/state")
    try:
        _, _, selected_ids = inspect_user_install(config_home)
        helper = Path(__file__).resolve().with_name("cam_toggle_helper.py")
        print("Administrator access is required to restore cameras and remove system integration.", flush=True)
        result = subprocess.run(["sudo", "/usr/bin/python3", "-I", str(helper), "uninstall", *selected_ids],
                                capture_output=False)
        if result.returncode:
            return result.returncode
        remove_user_install(config_home, state_home)
        if shutil.which("dms"):
            subprocess.run(["dms", "ipc", "plugin-scan", "scan"], capture_output=True, timeout=10)
        print("Uninstalled Cam Toggle. Managed connected cameras are enabled; all plugin rules and saved settings were removed.")
        print("Disconnected cameras return to the system's default authorization when reconnected.")
    except (OSError, ValueError, subprocess.TimeoutExpired) as exc:
        print("Uninstall failed: " + str(exc), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
