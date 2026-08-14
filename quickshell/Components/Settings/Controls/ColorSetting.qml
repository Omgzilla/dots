import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: root
    required property string label
    required property string value
    required property var appearance
    signal edited(string value)
    spacing: 12

    Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: 9
        color: root.value
        border.width: 1
        border.color: root.appearance.border
    }

    Text {
        Layout.fillWidth: true
        text: root.label
        color: root.appearance.text
        font.family: root.appearance.textFont
        font.pixelSize: 12
        font.weight: Font.Medium
    }

    TextField {
        id: input
        implicitWidth: 148
        implicitHeight: 34
        leftPadding: 10
        text: root.value
        color: root.appearance.text
        selectByMouse: true
        font.family: root.appearance.iconFont
        font.pixelSize: 11
        onEditingFinished: {
            const candidate = text.trim();
            if (/^#[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$/.test(candidate))
                root.edited(candidate);
            else
                text = root.value;
        }
        background: Rectangle {
            radius: 9
            color: Qt.darker(root.appearance.surface, 1.16)
            border.width: 1
            border.color: input.activeFocus ? root.appearance.accent : root.appearance.border
        }
    }
}
