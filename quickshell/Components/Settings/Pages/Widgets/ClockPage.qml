import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components.Settings.Controls
import qs.Services

ScrollView {
    id: root
    required property var appearance
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical: SettingsScrollBar { appearance: root.appearance }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    ColumnLayout {
        width: root.availableWidth
        spacing: 10

        Text {
            Layout.fillWidth: true
            text: Qt.formatDateTime(clock.date, Settings.clockFormat)
                  + (Settings.showDate
                     ? Settings.clockDateSeparator + Qt.formatDateTime(clock.date, Settings.dateFormat)
                     : "")
            color: root.appearance.accent
            font.family: root.appearance.textFont
            font.pixelSize: 18
            font.weight: Font.Medium
        }
        ToggleSetting { Layout.fillWidth: true; label: "Date next to clock"; value: Settings.showDate; offText: "Clock only"; onText: "Clock + date"; appearance: root.appearance; onEdited: value => Settings.showDate = value }
        ChoiceSetting {
            Layout.fillWidth: true
            label: "Time format"
            value: Settings.clockFormat
            options: [
                { "label": "24-hour — 18:45", "value": "HH:mm" },
                { "label": "12-hour — 6:45 PM", "value": "h:mm AP" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.clockFormat = value
        }
        ChoiceSetting {
            Layout.fillWidth: true
            enabled: Settings.showDate
            opacity: enabled ? 1 : 0.45
            label: "Date format"
            value: Settings.dateFormat
            options: [
                { "label": "Wed 22 Jul", "value": "ddd d MMM" },
                { "label": "Wednesday 22 July", "value": "dddd d MMMM" },
                { "label": "2026-07-22", "value": "yyyy-MM-dd" },
                { "label": "22/07/2026", "value": "dd/MM/yyyy" },
                { "label": "07/22/2026", "value": "MM/dd/yyyy" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.dateFormat = value
        }
        ChoiceSetting {
            Layout.fillWidth: true
            enabled: Settings.showDate
            opacity: enabled ? 1 : 0.45
            label: "Separator"
            value: Settings.clockDateSeparator
            options: [
                { "label": "Space", "value": "  " },
                { "label": "Bullet", "value": " • " },
                { "label": "Vertical line", "value": " | " },
                { "label": "Dash", "value": " — " }
            ]
            appearance: root.appearance
            onEdited: value => Settings.clockDateSeparator = value
        }
        ToggleSetting { Layout.fillWidth: true; label: "Calendar week numbers"; value: Settings.calendarShowWeekNumbers; offText: "Hide"; onText: "Show"; appearance: root.appearance; onEdited: value => Settings.calendarShowWeekNumbers = value }
        ChoiceSetting {
            Layout.fillWidth: true
            label: "First day of week"
            value: Settings.calendarFirstDay
            options: [
                { "label": "Monday", "value": "monday" },
                { "label": "Sunday", "value": "sunday" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.calendarFirstDay = value
        }
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; value: Settings.widgetCommand("clock"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("clock", value) }
        Item { Layout.fillHeight: true }
    }
}
