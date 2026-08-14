import QtQuick
import Quickshell

Loader {
    id: root
    required property string widgetName
    required property var barScreen
    required property var barWindow
    required property var appearance
    signal settingsRequested(var anchorItem, string category, string section)

    function componentSource(): string {
        switch (widgetName) {
        case "tags": return Quickshell.shellPath("Components/Widgets/Bar/TagsWidget.qml");
        case "layout": return Quickshell.shellPath("Components/Widgets/Bar/LayoutWidget.qml");
        case "activeWindow": return Quickshell.shellPath("Components/Widgets/Bar/ActiveWindowWidget.qml");
        case "tray": return Quickshell.shellPath("Components/Widgets/Bar/TrayWidget.qml");
        case "cpuUsage": return Quickshell.shellPath("Components/Widgets/Bar/CpuUsageWidget.qml");
        case "cpuTemperature": return Quickshell.shellPath("Components/Widgets/Bar/CpuTemperatureWidget.qml");
        case "gpuUsage": return Quickshell.shellPath("Components/Widgets/Bar/GpuUsageWidget.qml");
        case "gpuTemperature": return Quickshell.shellPath("Components/Widgets/Bar/GpuTemperatureWidget.qml");
        case "network": return Quickshell.shellPath("Components/Widgets/Bar/NetworkWidget.qml");
        case "audio": return Quickshell.shellPath("Components/Widgets/Bar/AudioWidget.qml");
        case "notifications": return Quickshell.shellPath("Components/Widgets/Bar/NotificationWidget.qml");
        case "media": return Quickshell.shellPath("Components/Widgets/Bar/MediaWidget.qml");
        case "clock": return Quickshell.shellPath("Components/Widgets/Bar/ClockWidget.qml");
        case "settings": return Quickshell.shellPath("Components/Widgets/Bar/SettingsWidget.qml");
        default: return "";
        }
    }

    function loadWidget(): void {
        const path = componentSource();
        if (path && barScreen && appearance) {
            const properties = { "barScreen": barScreen, "appearance": appearance };
            if (widgetName === "tray" || widgetName === "layout" || widgetName === "clock" || widgetName === "network" || widgetName === "audio" || widgetName === "notifications")
                properties.barWindow = barWindow;
            setSource(path, properties);
        }
    }

    Component.onCompleted: loadWidget()
    onWidgetNameChanged: loadWidget()

    Connections {
        target: root.item
        ignoreUnknownSignals: true
        function onSettingsRequested(anchorItem, category, section) {
            root.settingsRequested(anchorItem, category || "general", section || "");
        }
    }
}
