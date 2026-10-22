pragma ComponentBehavior: Bound
import QtQuick
import "../theme" as DmsTheme

Row {
    id: root
    property var options: []
    property string value: ""
    property color foreground: DmsTheme.Color.foreground
    property string fontFamily: DmsTheme.Style.font.family
    property real fontSize: DmsTheme.Style.font.caption
    property bool focusable: true
    signal changed(string value)
    spacing: DmsTheme.Style.spacing.sm
    Repeater {
        model: root.options
        Button {
            required property var modelData
            text: modelData.label
            selected: root.value === modelData.value
            bordered: true
            foreground: root.foreground
            fontFamily: root.fontFamily
            fontSize: root.fontSize
            focusable: root.focusable
            onClicked: root.changed(modelData.value)
        }
    }
}
