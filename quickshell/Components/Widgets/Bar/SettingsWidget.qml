import QtQuick

Item {
    id: root
    required property var barScreen
    required property var appearance
    signal settingsRequested(var anchorItem, string category, string section)
    implicitWidth: 27
    implicitHeight: 26

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.itemRadius
        color: mouse.containsMouse ? root.appearance.surfaceHover : "transparent"
    }
    Text {
        anchors.centerIn: parent
        text: "󰒓"
        color: root.appearance.textMuted
        font.family: root.appearance.iconFont
        font.pixelSize: 15
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Settings.runWidgetCommand("settings");
            else root.settingsRequested(root, "general", "");
        }
    }
}
