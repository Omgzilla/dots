import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Components.Common
import qs.Services

PopupWindow {
    id: root
    required property var barWindow
    required property var appearance
    property string selectedView: "latest"
    signal dismissRequested
    grabFocus: true
    readonly property bool showingHistory: selectedView === "history"
    readonly property var records: showingHistory ? NotificationService.history : NotificationService.active

    implicitWidth: 420
    implicitHeight: 500
    color: "transparent"
    anchor.window: barWindow
    anchor.rect.x: Settings.popupX("notifications", barWindow.width, implicitWidth)
    anchor.rect.y: Settings.edge === "top" ? barWindow.height + 7 : -implicitHeight - 7

    PopupFocusCloser { popup: root; onDismissRequested: root.dismissRequested() }

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.radius + 2
        color: root.appearance.background
        border.width: 1
        border.color: root.appearance.border

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 9

            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                ViewButton {
                    Layout.fillWidth: true
                    label: `Latest  ${NotificationService.active.length}`
                    selected: !root.showingHistory
                    appearance: root.appearance
                    onClicked: root.selectedView = "latest"
                }
                ViewButton {
                    Layout.fillWidth: true
                    label: `History  ${NotificationService.history.length}`
                    selected: root.showingHistory
                    appearance: root.appearance
                    onClicked: root.selectedView = "history"
                }
            }

            Rectangle {
                visible: !NotificationService.daemonOwned
                Layout.fillWidth: true
                implicitHeight: daemonWarning.implicitHeight + 16
                radius: 7
                color: root.appearance.surface
                border.width: 1
                border.color: root.appearance.urgent
                Text {
                    id: daemonWarning
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 8
                    text: "Another notification daemon owns the desktop notification service. Stop Mako, Dunst, SwayNC, or another Quickshell notification service, then restart this shell."
                    wrapMode: Text.WordWrap
                    color: root.appearance.text
                    font.family: root.appearance.textFont
                    font.pixelSize: 10
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: root.showingHistory ? "Notification history" : "Latest notifications"
                    color: root.appearance.text
                    font.family: root.appearance.textFont
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }
                Text {
                    text: root.showingHistory ? "Clear" : "Dismiss all"
                    color: actionMouse.containsMouse ? root.appearance.accent : root.appearance.textMuted
                    font.family: root.appearance.textFont
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    MouseArea {
                        id: actionMouse
                        anchors.fill: parent
                        anchors.margins: -5
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showingHistory
                                   ? NotificationService.clearHistory()
                                   : NotificationService.dismissAll()
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: root.appearance.border; opacity: 0.7 }

            ListView {
                id: notificationList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: root.records
                delegate: NotificationCard {
                    required property var modelData
                    width: ListView.view.width
                    record: modelData
                    historyMode: root.showingHistory
                    appearance: root.appearance
                }
                Text {
                    anchors.centerIn: parent
                    visible: notificationList.count === 0
                    text: root.showingHistory ? "No notification history" : "No notifications"
                    color: root.appearance.textMuted
                    font.family: root.appearance.textFont
                    font.pixelSize: 11
                }
            }
        }
    }

    component ViewButton: Rectangle {
        id: button
        required property string label
        required property bool selected
        required property var appearance
        signal clicked
        implicitHeight: 34
        radius: 7
        color: selected ? appearance.accent
                        : (buttonMouse.containsMouse ? appearance.surfaceHover : appearance.surface)
        Text {
            anchors.centerIn: parent
            text: button.label
            color: button.selected ? button.appearance.background : button.appearance.text
            font.family: button.appearance.textFont
            font.pixelSize: 11
            font.weight: Font.Medium
        }
        MouseArea {
            id: buttonMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }
}
