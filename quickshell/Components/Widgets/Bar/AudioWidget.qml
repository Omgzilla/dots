import QtQuick
import QtQuick.Layouts
import qs.Components.Menus
import qs.Services

Item {
    id: root
    required property var barScreen
    required property var barWindow
    required property var appearance
    property bool menuOpen: false
    readonly property int volume: Math.round((AudioService.sink?.audio?.volume ?? 0) * 100)
    readonly property bool muted: AudioService.sink?.audio?.muted ?? true

    function icon(): string { return muted || volume === 0 ? "󰖁" : (volume < 35 ? "󰕿" : (volume < 70 ? "󰖀" : "󰕾")); }
    implicitWidth: content.implicitWidth
    implicitHeight: 26

    RowLayout {
        id: content; anchors.centerIn: parent; spacing: 5
        Text { text: root.icon(); color: root.muted ? root.appearance.textMuted : root.appearance.text; font.family: root.appearance.iconFont; font.pixelSize: 15 }
        Text { visible: Settings.audioShowDeviceName; Layout.maximumWidth: 150; text: AudioService.displayName(AudioService.sink); color: root.appearance.textMuted; elide: Text.ElideRight; font.family: root.appearance.textFont; font.pixelSize: Math.max(8, root.appearance.fontSize - 2); font.weight: root.appearance.fontWeight }
        Text { text: root.volume; color: root.appearance.textMuted; font.family: root.appearance.textFont; font.pixelSize: Math.max(8, root.appearance.fontSize - 2); font.weight: root.appearance.fontWeight }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true; cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Settings.runWidgetCommand("audio");
            else root.menuOpen = !root.menuOpen;
        }
        onWheel: wheel => AudioService.setVolume(AudioService.sink, root.volume + (wheel.angleDelta.y > 0 ? 3 : -3))
    }
    AudioMenu { visible: root.menuOpen; barWindow: root.barWindow; appearance: root.appearance; onDismissRequested: root.menuOpen = false }
}
