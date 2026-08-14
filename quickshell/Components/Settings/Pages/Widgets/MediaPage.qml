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
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; value: Settings.widgetCommand("media"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("media", value) }
        Item { Layout.fillHeight: true }
    }
}
