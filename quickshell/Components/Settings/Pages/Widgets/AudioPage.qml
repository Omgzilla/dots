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

        ToggleSetting {
            Layout.fillWidth: true
            label: "Device name in bar"
            value: Settings.audioShowDeviceName
            offText: "Hide"
            onText: "Show"
            appearance: root.appearance
            onEdited: value => Settings.audioShowDeviceName = value
        }
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; value: Settings.widgetCommand("audio"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("audio", value) }
        Text {
            Layout.fillWidth: true
            text: "Input, output, volume and device controls are available under System → Audio."
            color: root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: 11
            wrapMode: Text.WordWrap
        }
        Item { Layout.fillHeight: true }
    }
}
