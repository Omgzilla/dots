import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

GridLayout {
    id: root

    required property string label
    required property string value
    required property var options
    required property var appearance
    property string description: ""
    signal edited(string value)
    columns: 2
    columnSpacing: 18
    rowSpacing: 2

    function optionIndex(value: string): int {
        const index = options.findIndex(option => option.value === value);
        return index < 0 ? 0 : index;
    }

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

    ComboBox {
        id: combo
        Layout.fillWidth: true
        Layout.minimumWidth: 210
        implicitHeight: 36
        model: root.options
        textRole: "label"
        valueRole: "value"
        currentIndex: root.optionIndex(root.value)
        font.family: root.appearance.textFont
        font.pixelSize: 11
        onActivated: index => root.edited(root.options[index].value)

        contentItem: Text {
            leftPadding: 10
            rightPadding: 28
            text: combo.displayText
            color: root.appearance.text
            font: combo.font
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            radius: 10
            color: combo.hovered ? root.appearance.surfaceHover : Qt.darker(root.appearance.surface, 1.16)
            border.width: 1
            border.color: combo.activeFocus ? root.appearance.accent : root.appearance.border
        }
        indicator: Text {
            x: combo.width - width - 9
            anchors.verticalCenter: parent.verticalCenter
            text: "󰅀"
            color: root.appearance.textMuted
            font.family: root.appearance.iconFont
            font.pixelSize: 10
        }
        delegate: ItemDelegate {
            id: optionDelegate
            required property int index
            width: combo.width
            highlighted: combo.highlightedIndex === index
            contentItem: Text {
                text: root.options[optionDelegate.index].label
                color: root.appearance.text
                font: combo.font
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: optionDelegate.highlighted ? root.appearance.surfaceHover : root.appearance.surface
            }
        }
        popup: Popup {
            y: combo.height + 3
            width: combo.width
            implicitHeight: Math.min(contentItem.implicitHeight + 4, 240)
            padding: 2
            contentItem: ListView {
                id: optionList
                clip: true
                implicitHeight: contentHeight
                model: combo.popup.visible ? combo.delegateModel : null
                currentIndex: combo.highlightedIndex
                ScrollBar.vertical: ScrollBar {
                    policy: optionList.contentHeight > optionList.height
                            ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                    width: 5
                    contentItem: Rectangle {
                        implicitWidth: 3
                        radius: 2
                        color: root.appearance.textMuted
                        opacity: parent.active || parent.hovered ? 0.55 : 0.22
                    }
                }
            }
            background: Rectangle {
                radius: 10
                color: root.appearance.surface
                border.width: 1
                border.color: root.appearance.border
            }
        }
    }
}
