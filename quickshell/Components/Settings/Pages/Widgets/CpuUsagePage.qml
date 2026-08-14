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
            text: PerformanceService.cpuUsageAvailable
                  ? `Current total CPU usage: ${PerformanceService.cpuUsage}%`
                  : "CPU usage is waiting for its first sample."
            color: PerformanceService.cpuUsageAvailable ? root.appearance.accent : root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; description: "Application or command opened from the widget."; value: Settings.widgetCommand("cpuUsage"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("cpuUsage", value) }
        Item { Layout.fillHeight: true }
    }
}
