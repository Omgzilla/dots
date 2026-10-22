import QtQuick
import "../theme" as DmsTheme

Item {
    id: root
    property bool checked: false
    property color foreground: DmsTheme.Color.foreground
    property bool hasCursor: false
    signal toggled()
    implicitWidth: DmsTheme.Style.space(42)
    implicitHeight: DmsTheme.Style.space(26)
    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: DmsTheme.Style.space(40)
        height: DmsTheme.Style.space(24)
        radius: height / 2
        color: root.checked ? DmsTheme.Color.accent : DmsTheme.Color.card
        border.color: root.hasCursor ? DmsTheme.Color.accent : DmsTheme.Color.outline
        border.width: 1
        Rectangle {
            x: root.checked ? parent.width - width - 3 : 3
            anchors.verticalCenter: parent.verticalCenter
            width: DmsTheme.Style.space(18)
            height: width
            radius: width / 2
            color: root.checked ? DmsTheme.Color.onAccent : DmsTheme.Color.dim
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: { root.forceActiveFocus(); root.toggled() }
    }
}
