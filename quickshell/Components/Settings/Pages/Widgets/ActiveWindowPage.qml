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
            label: "Application icon"
            value: Settings.activeWindowShowIcon
            offText: "Hide"
            onText: "Show"
            appearance: root.appearance
            onEdited: value => Settings.activeWindowShowIcon = value
        }
        ChoiceSetting {
            Layout.fillWidth: true
            label: "Title text"
            value: Settings.activeWindowTitleMode
            options: [
                { "label": "Short — application name", "value": "short" },
                { "label": "Long — full window title", "value": "long" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.activeWindowTitleMode = value
        }
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; value: Settings.widgetCommand("activeWindow"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("activeWindow", value) }
        Item { Layout.fillHeight: true }
    }
}
