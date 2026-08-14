import QtQuick
import QtQuick.Layouts
import qs.Services

Item {
    id: root
    required property var barScreen
    required property var appearance
    readonly property var player: MediaService.activePlayer
    readonly property string description: {
        if (!player) return "";
        if (player.trackArtist && player.trackTitle)
            return `${player.trackArtist} — ${player.trackTitle}`;
        return player.trackTitle || player.identity || "Playing";
    }

    visible: player !== null
    implicitWidth: visible ? Math.min(260, content.implicitWidth) : 0
    implicitHeight: 26

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.itemRadius
        color: mouse.containsMouse ? root.appearance.surfaceHover : "transparent"
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: 6

        Text {
            text: "󰎆"
            color: root.appearance.accent
            font.family: root.appearance.iconFont
            font.pixelSize: 13
        }
        Text {
            Layout.maximumWidth: 225
            text: root.description
            color: root.appearance.text
            elide: Text.ElideRight
            font.family: root.appearance.textFont
            font.pixelSize: Math.max(8, root.appearance.fontSize - 1)
            font.weight: root.appearance.fontWeight
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                Settings.runWidgetCommand("media");
            } else if (root.player?.canTogglePlaying) {
                root.player.togglePlaying();
            }
        }
    }
}
