import QtQuick
import qs.DCommon.Widgets as DCommon
import "../theme" as DmsTheme

DCommon.DActionButton {
    id: root
    property string iconText: ""
    property color foreground: DmsTheme.Color.foreground
    property string fontFamily: DmsTheme.Style.font.family
    property real fontSize: DmsTheme.Style.font.bodySmall
    property bool focusable: true
    iconName: iconText === "󰅖" ? "close" : iconText
    iconColor: foreground
    iconSize: DmsTheme.Style.space(20)
    buttonSize: DmsTheme.Style.spacing.controlHeight
    focusPolicy: focusable ? Qt.StrongFocus : Qt.NoFocus
    Accessible.name: tooltipText
}
