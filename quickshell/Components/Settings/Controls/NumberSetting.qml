import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

GridLayout {
    id: root
    required property string label
    required property int value
    required property int from
    required property int to
    required property var appearance
    property string description: ""
    signal edited(int value)
    columns: 2
    columnSpacing: 18
    rowSpacing: 2

    ColumnLayout {
        Layout.minimumWidth: 150
        Layout.preferredWidth: 190
        Layout.fillWidth: true
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

    RowLayout {
        Layout.minimumWidth: 210
        Layout.fillWidth: true
        spacing: 10

        Slider {
            Layout.fillWidth: true
            from: root.from
            to: root.to
            stepSize: 1
            value: root.value
            onMoved: root.edited(Math.round(value))
            background: Rectangle {
                x: parent.leftPadding
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                width: parent.availableWidth
                height: 5
                radius: 3
                color: Qt.darker(root.appearance.surface, 1.18)
                Rectangle {
                    width: parent.width * parent.parent.visualPosition
                    height: parent.height
                    radius: parent.radius
                    color: root.appearance.accent
                }
            }
            handle: Rectangle {
                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitWidth: 16
                implicitHeight: 16
                radius: 8
                color: root.appearance.surface
                border.width: 2
                border.color: root.appearance.accent
            }
        }

        TextField {
            id: input
            implicitWidth: 54
            implicitHeight: 32
            text: root.value.toString()
            color: root.appearance.text
            horizontalAlignment: TextInput.AlignHCenter
            selectByMouse: true
            inputMethodHints: Qt.ImhDigitsOnly
            font.family: root.appearance.iconFont
            font.pixelSize: 11
            validator: IntValidator { bottom: root.from; top: root.to }
            onEditingFinished: {
                const parsed = parseInt(text);
                if (!isNaN(parsed))
                    root.edited(Math.max(root.from, Math.min(root.to, parsed)));
                text = root.value.toString();
            }
            background: Rectangle {
                radius: 9
                color: Qt.darker(root.appearance.surface, 1.16)
                border.width: 1
                border.color: input.activeFocus ? root.appearance.accent : root.appearance.border
            }
        }
    }
}
