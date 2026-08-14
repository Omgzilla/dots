import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Components.Common
import qs.Components.Menus
import qs.Services

Item {
    id: root
    required property var barScreen
    required property var barWindow
    required property var appearance
    property bool menuOpen: false
    readonly property var output: MangoService.output(barScreen?.name ?? "")
    readonly property var currentLayout: MangoService.layoutInfo(output?.layout_symbol ?? "")

    implicitWidth: content.implicitWidth + 15
    implicitHeight: 26

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.itemRadius
        color: mouse.containsMouse || root.menuOpen ? root.appearance.surfaceHover : "transparent"
    }

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 4
        MaterialIcon {
            name: root.currentLayout.icon
            fallback: root.currentLayout.symbol
            fallbackFont: root.appearance.iconFont
            color: root.appearance.text
            size: 16
        }
        Text {
            text: "󰅀"
            color: root.appearance.textMuted
            font.family: root.appearance.iconFont
            font.pixelSize: 9
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Settings.runWidgetCommand("layout");
            else root.menuOpen = !root.menuOpen;
        }
    }

    LayoutMenu {
        visible: root.menuOpen
        barWindow: root.barWindow
        barScreen: root.barScreen
        appearance: root.appearance
        onLayoutSelected: root.menuOpen = false
        onDismissRequested: root.menuOpen = false
    }
}
