import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Components.Common
import qs.Services

PopupWindow {
    id: root
    required property var barWindow
    required property var barScreen
    required property var appearance
    visible: barScreen === Quickshell.screens[0] && NotificationService.popupRecords.length > 0
    implicitWidth: Settings.notificationWidth
    implicitHeight: toastColumn.implicitHeight
    color: "transparent"
    anchor.window: barWindow
    anchor.rect.x: Settings.notificationPosition === "left" ? Settings.contentPadding
                   : (Settings.notificationPosition === "center" ? (barWindow.width - implicitWidth) / 2
                      : barWindow.width - implicitWidth - Settings.contentPadding)
    anchor.rect.y: Settings.edge === "top" ? barWindow.height + 8 : -implicitHeight - 8
    ColumnLayout {
        id: toastColumn; anchors.left: parent.left; anchors.right: parent.right; spacing: 7
        Repeater {
            model: NotificationService.popupRecords
            delegate: NotificationCard { required property var modelData; Layout.fillWidth: true; record: modelData; appearance: root.appearance }
        }
    }
}
