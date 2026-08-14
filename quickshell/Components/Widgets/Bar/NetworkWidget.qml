import QtQuick
import Quickshell.Networking
import qs.Components.Menus
import qs.Services

Item {
    id: root
    required property var barScreen
    required property var barWindow
    required property var appearance
    property bool menuOpen: false

    function icon(): string {
        if (NetworkService.wiredConnected) return "󰈀";
        if (!NetworkService.wifiEnabled || !NetworkService.wifiConnected) return "󰤭";
        if (NetworkService.signalStrength >= 67) return "󰤨";
        if (NetworkService.signalStrength >= 34) return "󰤥";
        return "󰤟";
    }

    implicitWidth: 24
    implicitHeight: 26

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.itemRadius
        color: networkMouse.containsMouse || root.menuOpen ? root.appearance.surfaceHover : "transparent"
    }

    Text {
        anchors.centerIn: parent
        text: root.icon()
        color: NetworkService.connected ? root.appearance.text : root.appearance.textMuted
        font.family: root.appearance.iconFont
        font.pixelSize: 15
    }

    MouseArea {
        id: networkMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Settings.runWidgetCommand("network");
            else root.menuOpen = !root.menuOpen;
        }
    }

    NetworkMenu {
        visible: root.menuOpen
        barWindow: root.barWindow
        anchorItem: root
        appearance: root.appearance
        onDismissRequested: root.menuOpen = false
    }
}
