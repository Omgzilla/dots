import QtQuick
import "../theme" as DmsTheme

Button {
    id: root
    property string iconText: ""
    text: iconText === "󰅖" ? "close" : iconText
    fontFamily: "Material Symbols Rounded"
    fontSize: DmsTheme.Style.space(20)
    horizontalPadding: DmsTheme.Style.spacing.sm
    implicitWidth: DmsTheme.Style.space(32)
    implicitHeight: DmsTheme.Style.space(32)
    contentItem: Text {
        text: root.iconText === "󰅖" ? "close" : root.iconText
        color: root.foreground
        font.family: "Material Symbols Rounded"
        font.pixelSize: DmsTheme.Style.space(20)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Accessible.name: tooltipText
}
