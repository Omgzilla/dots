pragma ComponentBehavior: Bound

import QtQuick
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins
import qs.Services
import qs.Widgets as ShellWidgets

PluginComponent {
    id: root

    layerNamespacePlugin: "camtoggle"

    readonly property var selectedIds: Array.isArray(pluginData.selectedDeviceIds) ? pluginData.selectedDeviceIds : []
    readonly property var selectedDevices: monitor.devices.filter(device => selectedIds.indexOf(device.id) >= 0)
    readonly property int authorizedCount: selectedDevices.filter(device => device.authorized).length
    readonly property int missingCount: selectedIds.length - selectedDevices.length
    readonly property bool blocked: monitor.ready && selectedDevices.length > 0 && authorizedCount === 0
    readonly property string statusText: {
        if (monitor.busy && monitor.pendingAction !== "status")
            return "Switching…";
        if (!monitor.ready)
            return "Camera state unknown";
        if (!selectedIds.length)
            return "Choose cameras in plugin settings";
        if (!selectedDevices.length)
            return "Selected cameras disconnected";
        const state = blocked ? "Cameras off" : authorizedCount === selectedDevices.length && !selectedDevices.some(device => device.partiallyBlocked) ? "Cameras on" : "Mixed camera states";
        return state + (missingCount ? " · " + missingCount + " disconnected" : "");
    }
    readonly property string cameraIcon: !monitor.ready ? "warning" : blocked || (selectedIds.length > 0 && !selectedDevices.length) ? "videocam_off" : "videocam"
    readonly property color statusColor: monitor.lastError ? Theme.error : blocked ? Theme.primary : Theme.widgetIconColor
    readonly property string tooltipText: {
        if (!selectedIds.length)
            return "No device selected";
        return selectedIds.map(id => {
            const device = monitor.devices.find(candidate => candidate.id === id);
            const name = device?.name || pluginData.knownDevices?.[id]?.name || "Camera";
            const status = !monitor.ready ? "Unknown" : !device ? "Disconnected" : device.partiallyBlocked ? "Partly blocked" : device.authorized ? "On" : "Off";
            return name + " — " + status;
        }).join(" · ");
    }
    property Item hoveredIcon: null

    function hoverDevice(item, hovered) {
        if (hovered) {
            hoveredIcon = item;
            tooltipDelay.restart();
        } else if (hoveredIcon === item) {
            tooltipDelay.stop();
            hoveredIcon = null;
            deviceTooltip.hide();
        }
    }

    function positionDeviceTooltip() {
        const item = hoveredIcon;
        const screen = parentScreen || surfaceContext?.screen;
        if (!item || !screen || !surfaceLive)
            return;
        const global = item.mapToGlobal(item.width / 2, item.height);
        const point = surfaceContext?.screenPoint(item, item.width / 2, item.height) || Qt.point(global.x - screen.x, global.y - screen.y);
        let y = point.y + Theme.spacingS;
        if (!isVertical) {
            const position = axis?.edge === "bottom" ? SettingsData.Position.Bottom : SettingsData.Position.Top;
            const bounds = SettingsData.getBarBounds(screen, surfaceContext?.thickness ?? barThickness, position, barConfig);
            y = position === SettingsData.Position.Bottom ? bounds.y - deviceTooltip.implicitHeight - Theme.spacingS : bounds.y + bounds.height + Theme.spacingS;
        }
        deviceTooltip.show(tooltipText, point.x, y, screen, false, false);
    }

    onTooltipTextChanged: {
        if (deviceTooltip.visible)
            positionDeviceTooltip();
    }
    onSurfaceLiveChanged: {
        if (!surfaceLive) {
            tooltipDelay.stop();
            hoveredIcon = null;
            deviceTooltip.hide();
        }
    }

    Timer {
        id: tooltipDelay
        interval: Theme.tooltipDelay
        onTriggered: root.positionDeviceTooltip()
    }

    ShellWidgets.DTooltip {
        id: deviceTooltip
        screen: root.parentScreen
    }

    function toggleCamera() {
        monitor.runAction("toggle", selectedIds);
    }

    CamToggleMonitor {
        id: monitor
        onActionFailed: message => ToastService.showError("Cam Toggle", message)
    }

    ccWidgetIcon: cameraIcon
    ccWidgetPrimaryText: "Cam Toggle"
    ccWidgetSecondaryText: monitor.lastError ? "Toggle failed; see notification" : statusText
    ccWidgetIsActive: blocked
    onCcWidgetToggled: toggleCamera()

    pillClickAction: () => toggleCamera()
    pillRightClickAction: () => {
        monitor.runAction("status", []);
        if (monitor.lastError)
            ToastService.showError("Cam Toggle", monitor.lastError);
    }

    horizontalBarPill: Component {
        DIcon {
            id: horizontalIcon
            name: root.cameraIcon
            size: root.iconSize
            color: root.statusColor

            HoverHandler {
                onHoveredChanged: root.hoverDevice(horizontalIcon, hovered)
            }
        }
    }

    verticalBarPill: Component {
        DIcon {
            id: verticalIcon
            name: root.cameraIcon
            size: root.iconSize
            color: root.statusColor

            HoverHandler {
                onHoveredChanged: root.hoverDevice(verticalIcon, hovered)
            }
        }
    }
}
