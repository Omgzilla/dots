import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components.Common
import qs.Services

PopupWindow {
    id: root
    required property var barWindow
    required property var appearance
    signal dismissRequested
    grabFocus: true
    implicitWidth: 390
    implicitHeight: 430
    color: "transparent"
    anchor.window: barWindow
    anchor.rect.x: Settings.popupX("audio", barWindow.width, implicitWidth)
    anchor.rect.y: Settings.edge === "top" ? barWindow.height + 7 : -implicitHeight - 7

    PopupFocusCloser { popup: root; onDismissRequested: root.dismissRequested() }

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.radius + 2
        color: root.appearance.background
        border.width: 1
        border.color: root.appearance.border
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8
            Text { text: "Audio"; color: root.appearance.text; font.family: root.appearance.textFont; font.pixelSize: 15; font.weight: Font.Medium }
            AudioControl { title: "Output"; node: AudioService.sink; input: false; appearance: root.appearance }
            AudioControl { title: "Input"; node: AudioService.source; input: true; appearance: root.appearance }
            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: root.appearance.border }
            Text { text: "Output device"; color: root.appearance.textMuted; font.family: root.appearance.textFont; font.pixelSize: 10 }
            DeviceList { Layout.fillWidth: true; Layout.fillHeight: true; devices: AudioService.outputs; current: AudioService.sink; input: false; appearance: root.appearance }
            Text { text: "Input device"; color: root.appearance.textMuted; font.family: root.appearance.textFont; font.pixelSize: 10 }
            DeviceList { Layout.fillWidth: true; Layout.fillHeight: true; devices: AudioService.inputs; current: AudioService.source; input: true; appearance: root.appearance }
            SettingsButtonLike { Layout.fillWidth: true; text: "󰒓  Open Pavucontrol"; appearance: root.appearance; onClicked: AudioService.openPavucontrol() }
        }
    }

    component AudioControl: ColumnLayout {
        id: audioControl
        required property string title
        required property var node
        required property bool input
        required property var appearance
        RowLayout {
            Layout.fillWidth: true
            Text { Layout.fillWidth: true; text: `${audioControl.title}: ${AudioService.displayName(audioControl.node)}`; color: audioControl.appearance.text; elide: Text.ElideRight; font.family: audioControl.appearance.textFont; font.pixelSize: 11 }
            Text { text: `${Math.round((audioControl.node?.audio?.volume ?? 0) * 100)}%`; color: audioControl.appearance.textMuted; font.family: audioControl.appearance.textFont; font.pixelSize: 10 }
        }
        Slider {
            Layout.fillWidth: true; from: 0; to: 150; value: (audioControl.node?.audio?.volume ?? 0) * 100
            onMoved: AudioService.setVolume(audioControl.node, value)
        }
    }
    component DeviceList: ListView {
        id: deviceList
        required property var devices
        required property var current
        required property bool input
        required property var appearance
        implicitHeight: Math.min(contentHeight, 86)
        model: devices
        clip: true
        delegate: Rectangle {
            required property var modelData
            width: ListView.view.width; height: 28; radius: 6
            color: modelData === deviceList.current ? deviceList.appearance.accent : (deviceMouse.containsMouse ? deviceList.appearance.surfaceHover : "transparent")
            Text { anchors.fill: parent; anchors.leftMargin: 7; anchors.rightMargin: 7; text: AudioService.displayName(modelData); color: modelData === deviceList.current ? deviceList.appearance.background : deviceList.appearance.text; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight; font.family: deviceList.appearance.textFont; font.pixelSize: 10 }
            MouseArea { id: deviceMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: deviceList.input ? AudioService.setInput(parent.modelData.name) : AudioService.setOutput(parent.modelData.name) }
        }
    }
    component SettingsButtonLike: Rectangle {
        required property string text; required property var appearance; signal clicked
        implicitHeight: 31; radius: 7; color: buttonMouse.containsMouse ? appearance.surfaceHover : appearance.surface
        Text { anchors.centerIn: parent; text: parent.text; color: parent.appearance.text; font.family: parent.appearance.textFont; font.pixelSize: 10; font.weight: Font.Medium }
        MouseArea { id: buttonMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: parent.clicked() }
    }
}
