import QtQuick
import Quickshell

Item {
    id: root

    required property string name
    property string fallback: "󰕰"
    property string fallbackFont: "JetBrainsMono Nerd Font"
    property color color: "white"
    property int size: 16
    property int weight: 400
    property bool filled: false

    implicitWidth: size
    implicitHeight: size

    FontLoader {
        id: materialSymbols
        source: Quickshell.shellPath("Assets/fonts/MaterialSymbolsRounded.ttf")
    }

    Text {
        anchors.fill: parent
        text: materialSymbols.status === FontLoader.Ready ? root.name : root.fallback
        color: root.color
        font.family: materialSymbols.status === FontLoader.Ready ? materialSymbols.name : root.fallbackFont
        font.pixelSize: root.size
        font.weight: root.weight
        font.variableAxes: ({ "FILL": root.filled ? 1 : 0, "GRAD": 0, "opsz": 24, "wght": root.weight })
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
