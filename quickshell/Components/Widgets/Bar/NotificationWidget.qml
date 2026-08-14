import QtQuick
import QtQuick.Layouts
import qs.Components.Menus
import qs.Services

Item {
    id: root
    required property var barScreen
    required property var barWindow
    required property var appearance
    property bool menuOpen: false
    implicitWidth: content.implicitWidth
    implicitHeight: 26
    RowLayout {
        id: content; anchors.centerIn: parent; spacing: 3
        Text { text: NotificationService.active.length ? "󰂞" : "󰂚"; color: NotificationService.active.length ? root.appearance.accent : root.appearance.textMuted; font.family: root.appearance.iconFont; font.pixelSize: 14 }
        Text { visible: NotificationService.active.length > 0; text: NotificationService.active.length; color: root.appearance.textMuted; font.family: root.appearance.textFont; font.pixelSize: Math.max(8, root.appearance.fontSize - 3); font.weight: root.appearance.fontWeight }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Settings.runWidgetCommand("notifications");
            else root.menuOpen = !root.menuOpen;
        }
    }
    NotificationMenu { visible: root.menuOpen; barWindow: root.barWindow; appearance: root.appearance; onDismissRequested: root.menuOpen = false }
}
