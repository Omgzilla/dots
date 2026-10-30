#!/usr/bin/python3 -I
"""Root helper: block USB camera interfaces and persist their desired state."""

import argparse
from contextlib import contextmanager
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

HELPER_API_VERSION = 2
USB_ROOT = Path("/sys/bus/usb/devices")
STATE_DIR = Path("/var/lib/dms-camtoggle")
RULE_FILE = Path("/etc/udev/rules.d/70-dms-camtoggle.rules")
DEVICE_RESTORE_RULE = (
    "# Restore saved states; managed by Cam Toggle.\n"
    'ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", '
    'ATTR{bDeviceClass}!="09", RUN+="/usr/local/libexec/dms-camtoggle restore %k"\n'
)
RESTORE_RULE = DEVICE_RESTORE_RULE + (
    'ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_interface", '
    'RUN+="/usr/local/libexec/dms-camtoggle restore %k"\n'
)
PORT_PATTERN = re.compile(r"[0-9]+-[0-9]+(?:\.[0-9]+)*")
INTERFACE_PATTERN = re.compile(r"[0-9]+-[0-9]+(?:\.[0-9]+)*:[0-9]+\.[0-9]+")
KEY_PATTERN = re.compile(r"[a-f0-9]{64}")


def interface_classes(data):
    """Read cached descriptors, which remain available when deauthorized."""
    classes = set()
    offset = 0
    while offset < len(data):
        if offset + 2 > len(data):
            raise ValueError("Truncated USB descriptor")
        length, kind = data[offset:offset + 2]
        if length < 2 or offset + length > len(data):
            raise ValueError("Invalid USB descriptor length")
        if kind == 4:
            if length < 9:
                raise ValueError("Truncated USB interface descriptor")
            classes.add(data[offset + 5])
        offset += length
    return classes


def device_info(device):
    if not PORT_PATTERN.fullmatch(device.name):
        raise ValueError("Not a USB device port")
    device_class = (device / "bDeviceClass").read_text().strip()
    classes = interface_classes((device / "descriptors").read_bytes())
    if device_class == "09" or 9 in classes or 14 not in classes:
        raise ValueError("Not a USB video device, or contains a USB hub")
    vendor = (device / "idVendor").read_text().strip()
    product = (device / "idProduct").read_text().strip()
    try:
        serial = (device / "serial").read_text().strip()
    except FileNotFoundError:
        serial = ""
    try:
        name = (device / "product").read_text().strip()
    except FileNotFoundError:
        name = "USB camera"
    identity = [vendor, product, serial or "port:" + device.name]
    key = hashlib.sha256(json.dumps(identity).encode()).hexdigest()
    authorized = (device / "authorized").read_text().strip()
    if authorized not in ("0", "1"):
        raise ValueError("Unknown USB authorization state")
    allowed, partial = authorization_state(device, authorized)
    return {"id": key, "port": device.name, "name": name, "vendor": vendor,
            "product": product, "serial": serial, "authorized": allowed, "partiallyBlocked": partial, "deviceAuthorized": authorized == "1",
            "hasAudio": 1 in classes}


def scan_devices(usb_root=USB_ROOT):
    devices = []
    for device in sorted(usb_root.iterdir()):
        if not PORT_PATTERN.fullmatch(device.name):
            continue
        try:
            devices.append(device_info(device))
        except FileNotFoundError:
            continue
        except ValueError:
            continue  # Reject hubs, non-video devices and malformed descriptors.
    return devices


@contextmanager
def state_lock(state_dir):
    state_dir.mkdir(mode=0o700, parents=True, exist_ok=True)
    with (state_dir / "lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        yield


def load_states(state_dir):
    try:
        states = json.loads((state_dir / "state.json").read_text())
    except FileNotFoundError:
        return {}
    if not isinstance(states, dict) or any(
        not KEY_PATTERN.fullmatch(key) or type(value) is not int or value not in (0, 1)
        for key, value in states.items()
    ):
        raise ValueError("Invalid saved camera states")
    return states


def save_text(destination, content, mode=0o600):
    fd, temporary = tempfile.mkstemp(prefix="dms-camtoggle-", dir=destination.parent)
    try:
        with os.fdopen(fd, "w") as stream:
            os.fchmod(stream.fileno(), mode)
            stream.write(content)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, destination)
        directory_fd = os.open(destination.parent, os.O_RDONLY | os.O_DIRECTORY)
        try:
            os.fsync(directory_fd)
        finally:
            os.close(directory_fd)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def save_states(state_dir, states):
    save_text(state_dir / "state.json", json.dumps(states))


def restore_enabled(rule_file=RULE_FILE):
    try:
        rule = rule_file.read_text()
    except FileNotFoundError:
        return False
    if rule not in (RESTORE_RULE, DEVICE_RESTORE_RULE):
        raise ValueError("Cam Toggle's udev rule has been modified; review it before changing restoration")
    return True


def reload_udev_rules():
    try:
        subprocess.run(["/usr/bin/udevadm", "control", "--reload-rules"], check=True,
                       capture_output=True, text=True, timeout=10)
    except subprocess.CalledProcessError as exc:
        raise OSError("Cannot reload udev rules: " + exc.stderr.strip()) from exc
    except subprocess.TimeoutExpired as exc:
        raise OSError("Reloading udev rules timed out") from exc


def set_restore_enabled(enabled, usb_root=USB_ROOT, state_dir=STATE_DIR,
                        rule_file=RULE_FILE):
    if type(enabled) is not bool:
        raise ValueError("Expected a boolean restoration preference")
    with state_lock(state_dir):
        previous = restore_enabled(rule_file)
        if enabled:
            # Re-enabling restoration starts with current states, rather than
            # applying old states to cameras used while restoration was off.
            states = load_states(state_dir)
            for device in scan_devices(usb_root):
                if device["id"] in states:
                    states[device["id"]] = int(device["authorized"] and not device["partiallyBlocked"])
            save_states(state_dir, states)
        if previous == enabled and (not enabled or rule_file.read_text() == RESTORE_RULE):
            return {"error": ""}
        try:
            if enabled:
                save_text(rule_file, RESTORE_RULE, mode=0o644)
            else:
                rule_file.unlink()
            reload_udev_rules()
        except OSError as exc:
            # Keep the checkbox truthful if reloading the new rule fails.
            try:
                if previous:
                    save_text(rule_file, RESTORE_RULE, mode=0o644)
                elif rule_file.exists():
                    rule_file.unlink()
                reload_udev_rules()
            except OSError as rollback_error:
                raise OSError(f"{exc}; restoring the previous udev rule also failed: {rollback_error}") from exc
            raise
    return {"error": ""}


def interface_paths(device, port=None):
    port = port or device.name
    pattern = re.compile(re.escape(port) + r":[0-9]+\.[0-9]+")
    return [path for path in sorted(device.iterdir()) if pattern.fullmatch(path.name) and path.is_dir()]


def authorization_state(device, device_authorized):
    interfaces = interface_paths(device)
    values = [(interface / "authorized").read_text().strip() for interface in interfaces]
    if any(value not in ("0", "1") for value in values):
        raise ValueError("Unknown USB interface authorization state")
    if device_authorized != "1":
        return False, False
    if not values:
        return True, False
    return "1" in values, "0" in values and "1" in values


def write_attribute(directory_fd, attribute, value):
    fd = os.open(attribute, os.O_WRONLY | os.O_NOFOLLOW, dir_fd=directory_fd)
    with os.fdopen(fd, "w") as stream:
        stream.write(str(value) + "\n")


def write_authorized(device, value, usb_root):
    directory_fd = os.open(usb_root / device["port"], os.O_RDONLY | os.O_DIRECTORY)
    try:
        pinned = Path(f"/proc/self/fd/{directory_fd}")
        classes = interface_classes((pinned / "descriptors").read_bytes())
        if 14 not in classes or 9 in classes or (pinned / "bDeviceClass").read_text().strip() == "09":
            raise ValueError("Device is no longer a camera")
        for field, attribute in (("vendor", "idVendor"), ("product", "idProduct")):
            if (pinned / attribute).read_text().strip() != device[field]:
                raise ValueError("Camera identity changed")
        try:
            serial = (pinned / "serial").read_text().strip()
        except FileNotFoundError:
            serial = ""
        if serial != device["serial"]:
            raise ValueError("Camera serial changed")
        # Keep the device configured; only its interfaces are blocked.
        if (pinned / "authorized").read_text().strip() != "1":
            write_attribute(directory_fd, "authorized", 1)
        interfaces = interface_paths(pinned, device["port"])
        if not interfaces:
            raise OSError("No USB camera interfaces are available")
        for interface in interfaces:
            interface_fd = os.open(interface.name, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=directory_fd)
            try:
                if (interface / "authorized").read_text().strip() != str(value):
                    write_attribute(interface_fd, "authorized", value)
                if (interface / "authorized").read_text().strip() != str(value):
                    raise OSError("USB interface authorization did not change")
            finally:
                os.close(interface_fd)
        if value:
            # All interfaces must be authorized before probing multi-interface drivers.
            for interface in interfaces:
                if (interface / "driver").exists():
                    continue
                if os.stat(usb_root / device["port"]).st_ino != os.fstat(directory_fd).st_ino:
                    raise OSError("Camera disconnected before driver probing")
                fd = os.open(usb_root.parent / "drivers_probe", os.O_WRONLY | os.O_NOFOLLOW)
                with os.fdopen(fd, "w") as stream:
                    stream.write(interface.name + "\n")
    finally:
        os.close(directory_fd)



def set_devices(value, keys, usb_root=USB_ROOT, state_dir=STATE_DIR):
    if value not in (0, 1) or not keys or len(keys) > 64 or any(
        not KEY_PATTERN.fullmatch(key) for key in keys
    ):
        raise ValueError("Expected 0 or 1 and between 1 and 64 camera IDs")
    with state_lock(state_dir):
        available = scan_devices(usb_root)
        devices = {device["id"]: device for device in available}
        if len(devices) != len(available):
            raise ValueError("Duplicate camera serial numbers; cannot safely identify devices")
        if any(key not in devices for key in keys):
            raise ValueError("A selected camera disconnected; refresh and retry")
        states = load_states(state_dir)
        errors = []
        for key in dict.fromkeys(keys):
            device = devices[key]
            try:
                if device["authorized"] != bool(value) or device["partiallyBlocked"] or not device["deviceAuthorized"]:
                    write_authorized(device, value, usb_root)
                states[key] = value
            except (OSError, ValueError) as exc:
                errors.append(device["name"] + ": " + str(exc))
        save_states(state_dir, states)
        return {"error": "\n".join(errors)}


def restore_device(port, usb_root=USB_ROOT, state_dir=STATE_DIR,
                   rule_file=RULE_FILE):
    if INTERFACE_PATTERN.fullmatch(port):
        port = port.split(":", 1)[0]
    if not PORT_PATTERN.fullmatch(port):
        raise ValueError("Invalid USB device port")
    with state_lock(state_dir):
        if not restore_enabled(rule_file):
            return {"error": ""}
        states = load_states(state_dir)
        devices = scan_devices(usb_root)
        keys = [device["id"] for device in devices]
        for device in devices:
            if device["port"] != port or device["id"] not in states:
                continue
            if keys.count(device["id"]) != 1:
                raise ValueError("Duplicate camera serial numbers; cannot restore safely")
            value = states[device["id"]]
            if value == 0 and device["deviceAuthorized"] and not interface_paths(usb_root / port):
                # Configuration may still be in progress. Interface add events
                # reapply the saved block as each interface becomes available.
                continue
            if device["authorized"] != bool(value) or device["partiallyBlocked"] or not device["deviceAuthorized"]:
                write_authorized(device, value, usb_root)
    return {"error": ""}


def uninstall_system(keys=(), system_root=Path("/"), usb_root=USB_ROOT):
    """Restore managed cameras before removing this package's system files."""
    if len(keys) > 64 or any(not KEY_PATTERN.fullmatch(key) for key in keys):
        raise ValueError("Expected up to 64 camera IDs")
    state_dir = system_root / "var/lib/dms-camtoggle"
    rule_file = system_root / "etc/udev/rules.d/70-dms-camtoggle.rules"
    reenabled = []
    with state_lock(state_dir):
        had_rule = restore_enabled(rule_file)
        states = load_states(state_dir)
        managed = set(states) | set(keys)
        devices = scan_devices(usb_root)
        errors = []
        for device in devices:
            if device["id"] not in managed or (device["authorized"] and not device["partiallyBlocked"]):
                continue
            try:
                write_authorized(device, 1, usb_root)
                reenabled.append(device["name"])
            except (OSError, ValueError) as exc:
                errors.append(device["name"] + ": " + str(exc))
        if errors:
            raise OSError("Cannot re-enable all managed cameras; system integration was kept. " + "; ".join(errors))
        if had_rule:
            rule_file.unlink()
            try:
                reload_udev_rules()
            except OSError:
                save_text(rule_file, RESTORE_RULE, mode=0o644)
                reload_udev_rules()
                raise
        for relative in (
            "etc/sudoers.d/zz-dms-camtoggle",
            "usr/share/polkit-1/actions/org.dms.camtoggle.policy",
            "etc/polkit-1/rules.d/00-dms-camtoggle-admin.rules",
            "usr/local/libexec/dms-camtoggle",
        ):
            (system_root / relative).unlink(missing_ok=True)
        # The lock remains held until all of our saved state has been removed.
        shutil.rmtree(state_dir)
    return {"error": "", "reenabled": reenabled}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="action", required=True)
    commands.add_parser("info")
    setting = commands.add_parser("set")
    setting.add_argument("value", type=int, choices=(0, 1))
    setting.add_argument("keys", nargs="+")
    restore = commands.add_parser("restore")
    restore.add_argument("port")
    preference = commands.add_parser("set-restore")
    preference.add_argument("value", type=int, choices=(0, 1))
    uninstall = commands.add_parser("uninstall")
    uninstall.add_argument("keys", nargs="*")
    args = parser.parse_args()
    if args.action == "info":
        print(json.dumps({"apiVersion": HELPER_API_VERSION, "blockingMethod": "interfaces"}))
        return 0
    try:
        if os.geteuid() != 0:
            raise PermissionError("Run the installed helper through sudo")
        if args.action == "set":
            result = set_devices(args.value, args.keys)
        elif args.action == "set-restore":
            result = set_restore_enabled(bool(args.value))
        elif args.action == "uninstall":
            result = uninstall_system(args.keys)
        else:
            result = restore_device(args.port)
    except (OSError, ValueError) as exc:
        result = {"error": str(exc)}
    print(json.dumps(result))
    return 1 if result["error"] else 0


if __name__ == "__main__":
    sys.exit(main())
