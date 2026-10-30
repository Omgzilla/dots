# dms-camtoggle — Cam Toggle for DMS

A webcam privacy switch for DMS / Dux Shell 2.0. The bar button and Control Center tile block or enable the USB camera interfaces you choose in the plugin settings.

- Automatically discovers USB Video Class cameras, including cameras with blocked interfaces. The USB device remains enumerated while off.
- Settings contain one inclusion switch per camera. Newly discovered cameras start unchecked.
- Reads actual USB authorization state on startup, manual refresh, USB device events, and after camera actions. There is no periodic scan. Mixed states switch toward **off**; when all selected connected cameras are off, the next click switches them on.
- Optionally restores saved camera states after reboot or physical reconnect, even before DMS starts. Restoration is off by default; enabling installs a udev rule, and disabling removes it. Both changes require administrator authentication.
- Remembers discovered cameras in DMS settings and keeps them listed when unchecked or disconnected.

## What “off” means

The helper writes `0` to the `authorized` attribute of every interface belonging to a selected USB camera, including video, microphone and IR functions. Linux detaches those interfaces' drivers. The camera's USB device remains authorized and configured, allowing the same identity to stay discoverable while off. This avoids whole-device deauthorization, which caused the Anker webcam on the test setup to disappear from the USB bus after being left off.

Enabling first authorizes **all** interfaces, then asks Linux to probe unbound drivers through `/sys/bus/usb/drivers_probe`. This order is required for drivers using multiple interfaces. See the [Linux USB interface authorization documentation](https://docs.kernel.org/usb/authorization.html#interface-authorization).

This is a software block, not a guarantee that electrical power is removed. Firmware and the early boot environment run before the udev restoration rule, and restoration occurs after Linux enumerates the USB device. Use a hardware kill switch or disconnect the webcam if you need a physical guarantee. This blocks driver access rather than providing a hardware power cut. Root can override authorization; another device manager such as USBGuard may also apply a different policy.

The helper identifies cameras using vendor ID, product ID and serial number. Cameras without a serial number are remembered by USB port; moving one requires selecting it again. Duplicate serial identities are rejected rather than switching an ambiguous device. Non-USB cameras are not supported.

## Install

Dependencies: DMS 2.0+, Python 3 at `/usr/bin/python3`, sudo, udev, and polkit (`pkexec`) with a desktop authentication agent. DMS provides a polkit agent when enabled.

Both install steps are required for camera switching. The first installs the plugin; the second grants its restricted camera-control permission. Reboot/reconnect restoration remains optional.

From this repository, as your normal desktop user:

```sh
./install-dms-camtoggle.sh
sudo bash ./install-dms-camtoggle-system.sh "$USER"
```

The first command copies the plugin into `${XDG_CONFIG_HOME:-$HOME/.config}/dms/plugins/camToggle`. You can move or rename the checkout afterward. Re-run it after changing plugin files to update the installed copy. It repairs broken links left by the earlier installer and replaces links to the current checkout. It refuses to overwrite an unrelated plugin directory or a working link to another checkout. It also creates an empty `dms/config.d` directory if missing, working around a DMS 2.0 settings-discovery issue without editing existing settings. The second command installs:

| File | Purpose |
| --- | --- |
| `/usr/local/libexec/dms-camtoggle` | Root-owned, isolated Python helper |
| `/etc/sudoers.d/zz-dms-camtoggle` | Allows your user to call only the helper's `set` operation without a password |
| `/usr/share/polkit-1/actions/org.dms.camtoggle.policy` | Requires administrator authentication to install or remove the restoration rule |
| `/etc/polkit-1/rules.d/00-dms-camtoggle-admin.rules` | Authorizes the installer’s desktop account to authenticate this specific restoration action with its own password |
| `/var/lib/dms-camtoggle/state.json` | Created on first toggle; durable per-camera states, readable only by root |

The helper accepts only `0` or `1` and camera identity hashes. It resolves identities against current USB descriptors, rejects hubs and non-video devices, and writes only authorization attributes for the selected camera and its interfaces, plus the fixed USB driver-probe attribute. It never deauthorizes the whole USB device. A previously deauthorized device is authorized first so its interfaces can be recovered. It accepts no caller-supplied filesystem path or command. Do not grant sudo access to the editable copy in this repository.

Installation does not install a udev rule or switch any devices. In DMS Settings → Plugins, scan for plugins and enable **Cam Toggle**. Open its settings and check the cameras to include, then add the widget to the bar and/or Control Center. Click the widget to switch; right-click the bar widget to refresh. USB add/remove events refresh the device list automatically; the Refresh cameras button is also available. Background checks do not disable the settings controls.

Inclusion switches change membership only. A camera's last on/off state remains saved even if you later uncheck it. Recheck it to control it again. An initial camera state is saved only after you use the main toggle.

## Optional reboot and reconnect restoration

Open Cam Toggle settings and toggle **Restore camera state after reboot or reconnect**. The description explicitly states that this requires administrator (root) privileges.

- **Enable:** the desktop opens an administrator password dialog. After successful authentication, the helper installs `/etc/udev/rules.d/70-dms-camtoggle.rules` and reloads udev.
- **Disable:** authentication is requested again, then the helper removes that rule and reloads udev.
- **Cancel or authentication failure:** the checkbox keeps its previous value. A failed udev reload attempts to restore the previous rule.

This uses the [standard polkit authentication dialog](https://www.freedesktop.org/software/polkit/docs/latest/pkexec.1.html), rather than collecting passwords in the plugin. The policy uses `auth_admin` without retained authorization, so each change requests authentication under the installed policy. System administrators can override polkit policies. The installer authorizes its specified desktop account to authenticate this particular action with its own password. This is scoped to local, active requests for Cam Toggle restoration and does not grant administrator authentication for other applications. Site policies can override this behavior.

The restoration setting applies system-wide. It is read from the actual installed rule, not a saved UI checkbox. Enabling or disabling restoration does not change current camera authorization. Disabling leaves the cameras as they are until you switch them, reboot, or reconnect. Re-enabling restoration records the current state of previously managed connected cameras, so an old saved state is not unexpectedly reapplied.

The normal camera button uses its restricted passwordless sudo rule, installed as `zz-dms-camtoggle` so an earlier general per-user password rule does not override it. Changing restoration uses a separate, password-protected action; the sudo rule does not allow installing or removing udev rules.

After changing the helper code, rerun the system installer to update the root-owned copy. This interface-blocking update requires that one administrator step; ordinary UI changes do not. The plugin checks the helper API before switching, preventing an old helper from silently using whole-device deauthorization. An already-enabled restoration rule is updated to handle interface-add events as well as device-add events. After changing QML or the unprivileged controller, rerun `./install-dms-camtoggle.sh` and reload the plugin. If the plugin is missing, use Settings → Plugins → Scan for Plugins; a restart is not required.

## Diagnostics and recovery

A symlink becomes broken if its target checkout is renamed or moved. If an earlier installation is missing from DMS, run `./install-dms-camtoggle.sh` again to replace the broken link with a complete copy, then scan for plugins.

Discovery is read-only and does not need sudo:

```sh
python3 cam_toggle.py status
```

To recover a camera independently of DMS, copy its `id` from that output and run:

```sh
sudo /usr/local/libexec/dms-camtoggle set 1 CAMERA_ID
```

This enables it and saves “on”; it is reapplied at the next boot/reconnect only if restoration is enabled. A camera application may need to reopen the camera after enabling it. A driver loaded/unloaded manually via `modprobe` is independent of USB authorization; `uvcvideo` must be available for an authorized UVC camera to capture video.

udev restore failures appear in the system journal. A reboot or unplug/replug is needed to exercise the restore rule; installing it deliberately does not trigger all USB devices.

## Development checks

```sh
python3 -m unittest discover -s tests -v
bash -n install-dms-camtoggle.sh install-dms-camtoggle-system.sh uninstall-dms-camtoggle.sh
/usr/lib/qt6/bin/qmlformat CamToggle.qml > /dev/null
/usr/lib/qt6/bin/qmlformat CamToggleSettings.qml > /dev/null
/usr/lib/qt6/bin/qmlformat CamToggleMonitor.qml > /dev/null
```

Tests use a simulated sysfs tree and temporary state directory. They do not change real cameras or require root. Hardware switching and boot/reconnect restoration need a separate live check after installation.

## Uninstall

Run as your normal desktop user, from the checkout or the installed plugin directory:

```sh
./uninstall-dms-camtoggle.sh
```

It requests sudo authentication and performs a complete removal:

1. Re-enables connected cameras recorded as managed by Cam Toggle, including the currently selected cameras.
2. Removes its udev restoration rule and reloads udev.
3. Removes its `zz-dms-camtoggle` sudo rule, polkit policy and account-specific administrator rule, root helper, and all saved system camera states.
4. Removes the installed plugin, its DMS preferences, plugin state files, and references in bar, dock, and Control Center layouts.

If re-enabling a managed camera fails, it stops before removing the system integration. Unrelated cameras, other plugins, and their settings are preserved. Disconnected cameras return to the system's default authorization when reconnected because Cam Toggle's restoration rule is gone; another device manager may have its own policy. The uninstaller targets the current managed installation and preserves the source checkout.
