import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: root
    required property string label
    required property bool value
    required property var appearance
    property string offText: "Off"
    property string onText: "On"
    property string description: ""
    signal edited(bool value)
    spacing: 18

    ColumnLayout {
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

    Switch {
        id: toggle
        checked: root.value
        implicitWidth: 40
        implicitHeight: 22
        onToggled: root.edited(checked)
        indicator: Rectangle {
            implicitWidth: 38
            implicitHeight: 20
            radius: 10
            color: toggle.checked ? root.appearance.accent : Qt.darker(root.appearance.surface, 1.18)
            border.width: 1
            border.color: toggle.checked ? root.appearance.accent : root.appearance.border
            Rectangle {
                x: toggle.checked ? parent.width - width - 3 : 3
                anchors.verticalCenter: parent.verticalCenter
                width: 14
                height: 14
                radius: 7
                color: toggle.checked ? root.appearance.background : root.appearance.textMuted
                Behavior on x { NumberAnimation { duration: 120 } }
            }
        }
        contentItem: Item {}
    }
}
