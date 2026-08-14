import QtQuick
import QtQuick.Controls

Button {
    id: root
    required property var appearance
    property bool selected: false
    property bool compact: false
    property bool outlined: false
    implicitWidth: compact ? 30 : Math.max(72, contentItem.implicitWidth + 22)
    implicitHeight: compact ? 30 : 36
    font.family: appearance.textFont
    font.pixelSize: 12
    font.weight: Font.Medium

    background: Rectangle {
        radius: 9
        color: root.selected ? root.appearance.accent
                             : (root.hovered ? root.appearance.surfaceHover
                                             : (root.flat ? "transparent" : root.appearance.background))
        border.width: root.outlined && !root.selected ? 1 : 0
        border.color: root.appearance.border
        opacity: root.enabled ? 1 : 0.45
    }
    contentItem: Text {
        text: root.text
        color: root.selected ? root.appearance.background : root.appearance.text
        opacity: root.enabled ? 1 : 0.5
        font: root.font
        horizontalAlignment: root.compact ? Text.AlignHCenter : Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
