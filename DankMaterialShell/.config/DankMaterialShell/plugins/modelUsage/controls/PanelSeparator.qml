import QtQuick
import "../theme" as DmsTheme

Rectangle {
    property color foreground: DmsTheme.Color.foreground
    width: parent ? parent.width : 0
    implicitHeight: 1
    color: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.14)
}
