import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Services

Rectangle {
    id: root
    required property var record
    required property var appearance
    property bool historyMode: false
    property bool compact: Settings.notificationCompact
    readonly property var reminderOptions: [
        { "label": "5 minutes", "shortLabel": "5m", "minutes": 5 },
        { "label": "10 minutes", "shortLabel": "10m", "minutes": 10 },
        { "label": "15 minutes", "shortLabel": "15m", "minutes": 15 },
        { "label": "30 minutes", "shortLabel": "30m", "minutes": 30 },
        { "label": "1 hour", "shortLabel": "1h", "minutes": 60 },
        { "label": "2 hours", "shortLabel": "2h", "minutes": 120 }
    ]
    readonly property string reminderShortLabel: reminderOptions.find(option => option.minutes === Settings.notificationReminderMinutes)?.shortLabel ?? "15m"
    readonly property string iconSource: {
        const icon = record.appIcon || record.desktopEntry || "";
        if (!icon) return "";
        if (icon.startsWith("/") || icon.includes("://") || icon.startsWith("image:"))
            return icon.startsWith("/") ? `file://${icon}` : icon;
        return Quickshell.iconPath(icon, true);
    }
    implicitHeight: cardContent.implicitHeight + (compact ? 12 : 18)
    radius: Settings.notificationRadius
    color: Qt.rgba(appearance.surface.r, appearance.surface.g, appearance.surface.b, Settings.notificationOpacity / 100)
    border.width: Settings.notificationBorderWidth
    border.color: record.urgency === 2 ? appearance.urgent : appearance.border

    RowLayout {
        id: cardContent
        z: 1
        anchors.left: parent.left; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 9; anchors.rightMargin: 9; spacing: 8
        IconImage {
            visible: Settings.notificationShowIcon && source.toString().length > 0
            implicitWidth: root.compact ? 22 : 30; implicitHeight: implicitWidth
            source: root.iconSource
        }
        ColumnLayout {
            Layout.fillWidth: true; spacing: 2
            RowLayout {
                Layout.fillWidth: true
                Text { Layout.fillWidth: true; text: root.record.appName; color: root.appearance.textMuted; elide: Text.ElideRight; font.family: root.appearance.textFont; font.pixelSize: 9; font.weight: Font.Medium }
                Text { text: Qt.formatDateTime(new Date(root.record.timestamp), "HH:mm"); color: root.appearance.textMuted; font.family: root.appearance.textFont; font.pixelSize: 9 }
            }
            Text { Layout.fillWidth: true; text: root.record.summary; color: root.appearance.text; elide: Text.ElideRight; font.family: root.appearance.textFont; font.pixelSize: 11; font.weight: Font.DemiBold }
            Text { Layout.fillWidth: true; visible: Settings.notificationShowBody && text.length > 0; text: root.record.body; color: root.appearance.textMuted; wrapMode: Text.Wrap; maximumLineCount: root.compact ? 1 : 3; elide: Text.ElideRight; textFormat: Text.PlainText; font.family: root.appearance.textFont; font.pixelSize: 10 }
            Rectangle {
                id: reminderButton
                visible: !root.historyMode
                Layout.topMargin: 3
                implicitWidth: reminderLabel.implicitWidth + 18
                implicitHeight: 25
                radius: 6
                color: reminderMouse.containsMouse || reminderMenu.opened
                       ? root.appearance.surfaceHover : "transparent"
                border.width: 1
                border.color: root.appearance.border

                Text {
                    id: reminderLabel
                    anchors.centerIn: parent
                    text: `󰔛  Remind later · ${root.reminderShortLabel}  󰅀`
                    color: root.appearance.textMuted
                    font.family: root.appearance.textFont
                    font.pixelSize: 9
                    font.weight: Font.Medium
                }
                MouseArea {
                    id: reminderMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: reminderMenu.open()
                }
            }
        }
    }

    Popup {
        id: reminderMenu
        parent: root
        z: 20
        x: Math.max(0, reminderButton.mapToItem(root, 0, 0).x)
        y: reminderButton.mapToItem(root, 0, reminderButton.height + 3).y
        width: 128
        implicitHeight: reminderChoices.implicitHeight + 4
        padding: 2
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        contentItem: ColumnLayout {
            id: reminderChoices
            spacing: 1
            Repeater {
                model: root.reminderOptions
                delegate: Rectangle {
                    id: reminderChoice
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 28
                    radius: 5
                    color: choiceMouse.containsMouse
                           ? root.appearance.surfaceHover
                           : (Settings.notificationReminderMinutes === modelData.minutes
                              ? root.appearance.background : "transparent")
                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        text: reminderChoice.modelData.label
                        color: Settings.notificationReminderMinutes === reminderChoice.modelData.minutes
                               ? root.appearance.accent : root.appearance.text
                        verticalAlignment: Text.AlignVCenter
                        font.family: root.appearance.textFont
                        font.pixelSize: 10
                        font.weight: Font.Medium
                    }
                    MouseArea {
                        id: choiceMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Settings.notificationReminderMinutes = reminderChoice.modelData.minutes;
                            NotificationService.remind(root.record, reminderChoice.modelData.minutes);
                            reminderMenu.close();
                        }
                    }
                }
            }
        }
        background: Rectangle {
            radius: 7
            color: root.appearance.surface
            border.width: 1
            border.color: root.appearance.border
        }
    }

    MouseArea {
        id: cardMouse
        z: 0
        anchors.fill: parent; acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        hoverEnabled: true; cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) NotificationService.activate(root.record);
            else if (mouse.button === Qt.MiddleButton) NotificationService.remind(root.record);
            else if (root.historyMode) NotificationService.removeHistory(root.record);
            else NotificationService.archive(root.record, true);
        }
    }
}
