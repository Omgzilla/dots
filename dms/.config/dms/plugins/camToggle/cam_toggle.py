#!/usr/bin/env python3
"""Unprivileged discovery and toggle controller for the DMS widget."""

import argparse
import json
from pathlib import Path
import subprocess
import sys

from cam_toggle_helper import HELPER_API_VERSION, restore_enabled, scan_devices

HELPER = "/usr/local/libexec/dms-camtoggle"


def helper_compatible():
    try:
        result = subprocess.run([HELPER, "info"], capture_output=True, text=True, timeout=3)
        info = json.loads(result.stdout)
        return result.returncode == 0 and isinstance(info, dict) and info.get("apiVersion") == HELPER_API_VERSION and info.get("blockingMethod") == "interfaces"
    except (OSError, ValueError, subprocess.TimeoutExpired):
        return False


def snapshot():
    installed = Path(HELPER).is_file()
    try:
        return {"devices": scan_devices(), "error": "", "helperInstalled": installed,
                "restoreEnabled": restore_enabled(), "helperCompatible": installed and helper_compatible()}
    except (OSError, ValueError) as exc:
        return {"devices": [], "error": "Cannot inspect USB cameras: " + str(exc),
                "helperInstalled": installed, "restoreEnabled": False, "helperCompatible": False}


def control(action, selected):
    result = snapshot()
    if action == "status" or result["error"]:
        return result
    devices = [device for device in result["devices"] if device["id"] in selected]
    if not devices and action not in ("restore-enable", "restore-disable"):
        result["error"] = (
            "No cameras are selected. Choose devices in the plugin settings."
            if not selected else
            "The selected cameras are disconnected or unavailable. Reconnect them and refresh; your selection is still saved."
        )
        return result
    if not result["helperInstalled"]:
        result["error"] = "Install the USB camera helper first; see README.md."
        return result
    if not result["helperCompatible"]:
        result["error"] = "Update the system helper for interface blocking: sudo bash ./install-dms-camtoggle-system.sh YOUR_USERNAME"
        return result
    # Mixed states always switch toward privacy; only all-off switches back on.
    changing_restore = action in ("restore-enable", "restore-disable")
    if changing_restore:
        value = int(action == "restore-enable")
        command = ["pkexec", "--disable-internal-agent", HELPER, "set-restore", str(value)]
    else:
        value = int(all(not device["authorized"] for device in devices)) if action == "toggle" else int(action == "enable")
        command = ["sudo", "-n", "--", HELPER, "set", str(value)] + [device["id"] for device in devices]
    error = ""
    cancelled = False
    try:
        completed = subprocess.run(
            command,
            capture_output=True, text=True, timeout=180 if changing_restore else 20,
        )
        cancelled = changing_restore and completed.returncode == 126
        if not cancelled and completed.stdout.strip():
            error = json.loads(completed.stdout).get("error", "")
        if not cancelled and completed.returncode and not error:
            error = completed.stderr.strip()[:2000] or "USB camera helper failed."
        if changing_restore and completed.returncode == 127:
            error = "Administrator authentication failed or no desktop authentication agent is running. The restoration setting was not changed."
        if not changing_restore and completed.returncode and "sudo" in completed.stderr.lower():
            error = ("Passwordless camera permission was rejected. Re-run install-dms-camtoggle-system.sh "
                     "for your desktop user to repair the sudo rule.\n" + error)
    except subprocess.TimeoutExpired:
        error = "Camera helper timed out. Refresh to check the current state."
    except (OSError, ValueError) as exc:
        error = str(exc)
    result = snapshot()
    if not error and not cancelled and changing_restore and result["restoreEnabled"] != bool(value):
        error = "The camera restoration preference did not change. Refresh and retry."
    if not error and not changing_restore and any(
        device["authorized"] != bool(value) or device.get("partiallyBlocked", False)
        for device in result["devices"] if device["id"] in selected
    ):
        error = "A camera did not stay in the requested state. Refresh and retry."
    if not error and not changing_restore:
        connected = {device["id"] for device in result["devices"]}
        if any(device["id"] not in connected for device in devices):
            error = "A selected camera left the USB bus while switching. Reconnect it to recover and check the USB cable or hub."
    result["error"] = error or result["error"]
    result["cancelled"] = cancelled
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("status", "toggle", "enable", "disable", "restore-enable", "restore-disable"))
    parser.add_argument("selected", nargs="?", default="[]", help="JSON array of selected camera IDs")
    args = parser.parse_args()
    try:
        selected = json.loads(args.selected)
        if not isinstance(selected, list) or any(not isinstance(key, str) for key in selected):
            raise ValueError("Expected an array of camera IDs")
        result = control(args.action, selected)
    except ValueError as exc:
        result = {"devices": [], "error": str(exc)}
    print(json.dumps(result))
    return 1 if result["error"] else 0


if __name__ == "__main__":
    sys.exit(main())
