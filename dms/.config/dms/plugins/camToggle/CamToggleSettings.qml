pragma ComponentBehavior: Bound

import QtQuick
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "camToggle"

    readonly property var settings: SettingsData.getPluginSettingsForPlugin(pluginId)
    readonly property var selectedIds: Array.isArray(settings.selectedDeviceIds) ? settings.selectedDeviceIds : []
    readonly property var knownDevices: settings.knownDevices || ({})
    readonly property var deviceRows: {
        const rows = monitor.devices.map(device => Object.assign({}, device, {
                connected: true
            }));
        const rememberedIds = Array.from(new Set(Object.keys(knownDevices).concat(selectedIds)));
        for (const id of rememberedIds) {
            if (!rows.some(device => device.id === id))
                rows.push({
                    id: id,
                    name: knownDevices[id]?.name || "Disconnected camera",
                    connected: false
                });
        }
        return rows;
    }

    function rememberDevices() {
        if (!pluginService)
            return;
        const known = Object.assign({}, knownDevices);
        for (const device of monitor.devices) {
            known[device.id] = {
                name: device.name,
                vendor: device.vendor,
                product: device.product,
                serial: device.serial,
                port: device.port,
                hasAudio: device.hasAudio
            };
        }
        if (JSON.stringify(known) !== JSON.stringify(knownDevices))
            saveValue("knownDevices", known);
    }

    function selectDevice(device, included) {
        let ids = selectedIds.filter(id => id !== device.id);
        if (included)
            ids.push(device.id);
        const known = Object.assign({}, knownDevices);
        known[device.id] = Object.assign({}, known[device.id], {
            name: device.name
        });
        saveValue("knownDevices", known);
        saveValue("selectedDeviceIds", ids);
    }

    Column {
        function loadValue() {
            root.rememberDevices();
        }
        width: parent.width
        spacing: Theme.spacingM

        CamToggleMonitor {
            id: monitor
            onDevicesChanged: root.rememberDevices()
        }

        StyledText {
            width: parent.width
            text: "Cameras included in the toggle"
            font.pixelSize: Theme.fontSizeLarge
            font.weight: Font.DemiBold
            color: Theme.surfaceText
        }

        StyledText {
            width: parent.width
            text: "USB webcams appear automatically. These switches only choose which cameras the main toggle controls; they do not switch cameras on or off. Remembered cameras stay listed when disconnected or unchecked."
            wrapMode: Text.WordWrap
            color: Theme.surfaceVariantText
            font.pixelSize: Theme.fontSizeSmall
        }

        Repeater {
            model: root.deviceRows
            DToggle {
                required property var modelData
                width: parent.width
                text: "Include " + modelData.name
                description: !modelData.connected ? "Disconnected · Reconnect the camera to control it" : (modelData.partiallyBlocked ? "Partly blocked" : modelData.authorized ? "On · Interfaces enabled" : "Off · Interfaces blocked") + " · " + modelData.vendor + ":" + modelData.product + " · Port " + modelData.port + (modelData.hasAudio ? " · Also disables camera microphone" : "")
                checked: root.selectedIds.indexOf(modelData.id) >= 0
                enabled: root.pluginService !== null
                onToggled: included => root.selectDevice(modelData, included)
            }
        }

        StyledText {
            width: parent.width
            visible: !root.deviceRows.length
            text: monitor.ready ? "No USB webcams found. Plug in a webcam to include it." : "Looking for USB webcams…"
            color: Theme.surfaceVariantText
            wrapMode: Text.WordWrap
        }

        StyledText {
            width: parent.width
            visible: monitor.ready && !monitor.helperInstalled
            text: "System helper is not installed. Follow README.md to enable camera switching and restore the state after reboot."
            color: Theme.error
            wrapMode: Text.WordWrap
        }

        StyledText {
            width: parent.width
            visible: monitor.ready && monitor.helperInstalled && !monitor.helperCompatible
            text: "The system helper needs an update for interface blocking. Run the system installer once with administrator access."
            color: Theme.error
            wrapMode: Text.WordWrap
        }

        StyledText {
            width: parent.width
            visible: !!monitor.lastError
            text: monitor.lastError
            color: Theme.error
            wrapMode: Text.WordWrap
        }

        DButton {
            text: "Refresh cameras"
            enabled: !monitor.actionBusy
            onClicked: monitor.runAction("status", [])
        }

        DToggle {
            width: parent.width
            text: "Restore camera state after reboot or reconnect"
            description: "Requires administrator (root) privileges. Enabling installs a system udev rule; disabling removes it. Either change opens an administrator password dialog. Applies system-wide."
            checked: monitor.restoreEnabled
            enabled: monitor.ready && monitor.helperCompatible && !monitor.actionBusy
            onToggled: enabled => monitor.runAction(enabled ? "restore-enable" : "restore-disable", [])
        }

        StyledText {
            width: parent.width
            visible: monitor.busy && monitor.pendingAction.indexOf("restore-") === 0
            text: "Waiting for administrator authentication…"
            color: Theme.surfaceVariantText
            wrapMode: Text.WordWrap
        }

        StyledText {
            width: parent.width
            text: "Off blocks every interface on the selected camera, including microphone or IR functions. The USB device stays connected so it can be enabled again. Changing this list or the restoration setting does not switch a camera on or off. Interface switching requires the system helper. This is a software block; USB power remains on."
            wrapMode: Text.WordWrap
            color: Theme.surfaceVariantText
            font.pixelSize: Theme.fontSizeSmall
        }
    }
}
