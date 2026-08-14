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
        width: parent.availableWidth
        spacing: 9
        NumberSetting { Layout.fillWidth: true; label: "Edge gap"; description: "Distance from the selected screen edge."; value: Settings.edgeGap; from: 0; to: 30; appearance: root.appearance; onEdited: value => Settings.edgeGap = value }
        NumberSetting { Layout.fillWidth: true; label: "Side gap"; description: "Horizontal margin on either side."; value: Settings.sideGap; from: 0; to: 40; appearance: root.appearance; onEdited: value => Settings.sideGap = value }
        NumberSetting { Layout.fillWidth: true; label: "Content padding"; description: "Space inside the bar surface."; value: Settings.contentPadding; from: 2; to: 24; appearance: root.appearance; onEdited: value => Settings.contentPadding = value }
        NumberSetting { Layout.fillWidth: true; label: "Widget spacing"; description: "Space between neighboring widgets."; value: Settings.widgetSpacing; from: 0; to: 24; appearance: root.appearance; onEdited: value => Settings.widgetSpacing = value }
        NumberSetting { Layout.fillWidth: true; label: "Corner radius"; description: "Roundness of the bar corners."; value: Settings.radius; from: 0; to: 24; appearance: root.appearance; onEdited: value => Settings.radius = value }
    }
}
