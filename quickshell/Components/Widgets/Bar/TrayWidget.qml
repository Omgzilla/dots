import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

RowLayout {
    id: root
    required property var barScreen
    required property var barWindow
    required property var appearance
    spacing: 3
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items

        Item {
            id: delegateRoot
            required property var modelData
            implicitWidth: 21
            implicitHeight: 24

            Rectangle {
                anchors.fill: parent
                radius: root.appearance.itemRadius
                color: trayMouse.containsMouse ? root.appearance.surfaceHover : "transparent"
            }

            IconImage {
                anchors.centerIn: parent
                implicitWidth: 15
                implicitHeight: 15
                source: delegateRoot.modelData.icon
            }

            MouseArea {
                id: trayMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                onClicked: mouse => {
                    if ((mouse.button === Qt.RightButton || delegateRoot.modelData.onlyMenu)
                            && delegateRoot.modelData.hasMenu) {
                        const point = delegateRoot.mapToItem(root.barWindow.contentItem,
                                                             mouse.x, mouse.y);
                        delegateRoot.modelData.display(root.barWindow,
                                                       Math.round(point.x), Math.round(point.y));
                    } else if (mouse.button === Qt.MiddleButton) {
                        delegateRoot.modelData.secondaryActivate();
                    } else {
                        delegateRoot.modelData.activate();
                    }
                }
                onWheel: wheel => delegateRoot.modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}
