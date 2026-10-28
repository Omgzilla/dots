import QtQuick
import "../theme" as DmsTheme

Rectangle {
    property var borderSpec: ({color: DmsTheme.Color.outline, width: 1})
    property real padding: 0
    readonly property real contentLeftInset: padding + border.width
    readonly property real contentRightInset: padding + border.width
    readonly property real contentTopInset: padding + border.width
    readonly property real contentBottomInset: padding + border.width
    border.color: borderSpec.color
    border.width: borderSpec.width
    radius: DmsTheme.Style.cornerRadius
    color: DmsTheme.Color.card
}
