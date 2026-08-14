import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

GridLayout {
    id: root
    required property string label
    required property string value
    required property var appearance
    property string description: ""
    signal edited(string value)
    columns: 2
    columnSpacing: 18
    rowSpacing: 2

    ColumnLayout {
        Layout.minimumWidth: 150
        Layout.preferredWidth: 190
        Layout.fillWidth: true
        spacing: 1
        Text {
            Layout.fillWidth: true
            text: root.label
            color: root.appearance.text
            font.family: root.appearance.textFont
            font.pixelSize: 12
            font.weight: Font.Medium
            elide: Text.ElideRight
        }
        Text {
            visible: root.description.length > 0
            Layout.fillWidth: true
            text: root.description
            color: root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: 9
            wrapMode: Text.WordWrap
        }
    }

    TextField {
        id: commandInput
        Layout.fillWidth: true
        Layout.minimumWidth: 210
        implicitHeight: 36
        leftPadding: 12
        rightPadding: 12
        text: root.value
        placeholderText: "Application or shell command…"
        color: root.appearance.text
        placeholderTextColor: root.appearance.textMuted
        selectByMouse: true
        font.family: root.appearance.textFont
        font.pixelSize: 11
        onEditingFinished: {
            root.edited(text);
            text = root.value;
        }
        background: Rectangle {
            radius: 10
            color: Qt.darker(root.appearance.surface, 1.16)
            border.width: 1
            border.color: commandInput.activeFocus ? root.appearance.accent : root.appearance.border
        }
    }
}
