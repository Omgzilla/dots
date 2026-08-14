import QtQuick
import QtQuick.Controls

ScrollBar {
    id: root
    required property var appearance
    width: 5
    policy: ScrollBar.AsNeeded

    background: Item {}
    contentItem: Rectangle {
        implicitWidth: 3
        radius: 2
        color: root.appearance.accent
        opacity: root.active || root.hovered ? 0.72 : 0.28
    }
}
