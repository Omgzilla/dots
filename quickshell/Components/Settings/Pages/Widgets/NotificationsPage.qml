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

        ToggleSetting { Layout.fillWidth: true; label: "Notification daemon"; value: Settings.notificationsEnabled; appearance: root.appearance; onEdited: value => Settings.notificationsEnabled = value }
        ToggleSetting { Layout.fillWidth: true; label: "Popup notifications"; value: Settings.notificationPopups; appearance: root.appearance; onEdited: value => Settings.notificationPopups = value }
        ChoiceSetting {
            Layout.fillWidth: true
            label: "Popup position"
            value: Settings.notificationPosition
            options: [
                { "label": "Left", "value": "left" },
                { "label": "Center", "value": "center" },
                { "label": "Right", "value": "right" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.notificationPosition = value
        }
        ToggleSetting { Layout.fillWidth: true; label: "Application icons"; value: Settings.notificationShowIcon; offText: "Hide"; onText: "Show"; appearance: root.appearance; onEdited: value => Settings.notificationShowIcon = value }
        ToggleSetting { Layout.fillWidth: true; label: "Notification body"; value: Settings.notificationShowBody; offText: "Hide"; onText: "Show"; appearance: root.appearance; onEdited: value => Settings.notificationShowBody = value }
        ToggleSetting { Layout.fillWidth: true; label: "Card density"; value: Settings.notificationCompact; offText: "Comfortable"; onText: "Compact"; appearance: root.appearance; onEdited: value => Settings.notificationCompact = value }
        NumberSetting { Layout.fillWidth: true; label: "Popup width"; value: Settings.notificationWidth; from: 280; to: 600; appearance: root.appearance; onEdited: value => Settings.notificationWidth = value }
        NumberSetting { Layout.fillWidth: true; label: "Popup timeout (seconds)"; value: Settings.notificationTimeout; from: 1; to: 30; appearance: root.appearance; onEdited: value => Settings.notificationTimeout = value }
        NumberSetting { Layout.fillWidth: true; label: "Maximum visible popups"; value: Settings.notificationMaxVisible; from: 1; to: 8; appearance: root.appearance; onEdited: value => Settings.notificationMaxVisible = value }
        NumberSetting { Layout.fillWidth: true; label: "Card opacity (%)"; value: Settings.notificationOpacity; from: 20; to: 100; appearance: root.appearance; onEdited: value => Settings.notificationOpacity = value }
        NumberSetting { Layout.fillWidth: true; label: "Corner radius"; value: Settings.notificationRadius; from: 0; to: 24; appearance: root.appearance; onEdited: value => Settings.notificationRadius = value }
        NumberSetting { Layout.fillWidth: true; label: "Border width"; value: Settings.notificationBorderWidth; from: 0; to: 4; appearance: root.appearance; onEdited: value => Settings.notificationBorderWidth = value }
        NumberSetting { Layout.fillWidth: true; label: "History limit"; value: Settings.notificationHistoryLimit; from: 10; to: 500; appearance: root.appearance; onEdited: value => Settings.notificationHistoryLimit = value }
        ChoiceSetting {
            Layout.fillWidth: true
            label: "Default reminder delay"
            value: String(Settings.notificationReminderMinutes)
            options: [
                { "label": "5 minutes", "value": "5" },
                { "label": "10 minutes", "value": "10" },
                { "label": "15 minutes", "value": "15" },
                { "label": "30 minutes", "value": "30" },
                { "label": "1 hour", "value": "60" },
                { "label": "2 hours", "value": "120" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.notificationReminderMinutes = Number(value)
        }
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; value: Settings.widgetCommand("notifications"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("notifications", value) }
        Item { Layout.fillHeight: true }
    }
}
