import QtQuick
import QtQuick.Layouts

Item {
    id: root
    required property var appearance
    property alias text: title.text
    property bool separator: false
    Layout.fillWidth: true
    implicitHeight: title.implicitHeight + 18 + (separator ? 7 : 0)

    Text {
        id: title
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 10
        color: root.appearance.text
        font.family: root.appearance.textFont
        font.pixelSize: 15
        font.weight: Font.DemiBold
        elide: Text.ElideRight
    }

    Rectangle {
        visible: root.separator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        implicitHeight: 1
        color: root.appearance.border
        opacity: 0.65
    }
}
