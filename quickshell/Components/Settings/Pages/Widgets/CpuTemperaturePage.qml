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
            text: PerformanceService.cpuTemperatureAvailable
                  ? `Current package temperature: ${PerformanceService.cpuTemperature}°C`
                  : "No supported CPU temperature sensor was found."
            color: PerformanceService.cpuTemperatureAvailable ? root.appearance.accent : root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; description: "Application or command opened from the widget."; value: Settings.widgetCommand("cpuTemperature"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("cpuTemperature", value) }
        Item { Layout.fillHeight: true }
    }
}
