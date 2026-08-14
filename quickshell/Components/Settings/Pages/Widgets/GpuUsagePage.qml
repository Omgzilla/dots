import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components.Settings.Controls
import qs.Services

ScrollView {
    id: root
    required property var appearance
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical: SettingsScrollBar { appearance: root.appearance }

    ColumnLayout {
        width: root.availableWidth
        spacing: 10
        Text {
            Layout.fillWidth: true
            text: PerformanceService.gpuUsageAvailable
                  ? `Current GPU usage: ${PerformanceService.gpuUsage}%`
                  : "No supported GPU utilization source was found."
            color: PerformanceService.gpuUsageAvailable ? root.appearance.accent : root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; description: "Application or command opened from the widget."; value: Settings.widgetCommand("gpuUsage"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("gpuUsage", value) }
        Item { Layout.fillHeight: true }
    }
}
