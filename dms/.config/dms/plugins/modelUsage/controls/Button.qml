import QtQuick
import qs.DCommon.Widgets as DCommon
import "../theme" as DmsTheme

DCommon.DButton {
    id: root
    property color foreground: DmsTheme.Color.foreground
    property color surface: DmsTheme.Color.popups.background
    property color accent: DmsTheme.Color.accent
    property string fontFamily: DmsTheme.Style.font.family
    property real fontSize: DmsTheme.Style.font.bodySmall
    horizontalPadding: DmsTheme.Style.spacing.lg
    verticalPadding: DmsTheme.Style.spacing.sm
    property bool bordered: false
    property bool selected: false
    property bool focusable: true
    focusPolicy: focusable ? Qt.StrongFocus : Qt.NoFocus
    buttonHeight: Math.max(DmsTheme.Style.spacing.controlHeight, fontSize + verticalPadding * 2)
    backgroundColor: selected ? accent : "transparent"
    textColor: selected ? DmsTheme.Color.onAccent : foreground
    border.width: bordered ? 1 : 0
    border.color: selected ? accent : DmsTheme.Color.outline
    Accessible.name: text
}
