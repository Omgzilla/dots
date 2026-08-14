import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components.Settings.Controls

ScrollView {
    id: root
    required property var appearance
    signal openWidgetSettings(string section)
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical: SettingsScrollBar { appearance: root.appearance }

    ColumnLayout {
        width: parent.availableWidth
        spacing: 6

        Text {
            Layout.fillWidth: true
            text: "Drag components between sections. Their top-to-bottom order matches their order in the bar."
            wrapMode: Text.WordWrap
            color: root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: 11
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5
            ComponentLane { Layout.fillWidth: true; section: "left"; title: "Left"; appearance: root.appearance; onSettingsRequested: widgetId => root.openWidgetSettings(widgetId) }
            ComponentLane { Layout.fillWidth: true; section: "center"; title: "Center"; appearance: root.appearance; onSettingsRequested: widgetId => root.openWidgetSettings(widgetId) }
            ComponentLane { Layout.fillWidth: true; section: "right"; title: "Right"; appearance: root.appearance; onSettingsRequested: widgetId => root.openWidgetSettings(widgetId) }
        }

        ComponentLane {
            Layout.fillWidth: true
            section: "hidden"
            title: "Hidden"
            appearance: root.appearance
            onSettingsRequested: widgetId => root.openWidgetSettings(widgetId)
        }
    }
}
