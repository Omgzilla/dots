import QtQuick
import QtQuick.Controls as Controls
import "../theme" as DmsTheme

Controls.AbstractButton {
    id: root
    property color foreground: DmsTheme.Color.foreground
    // Controls already owns background (an Item); upstream uses a color here.
    property color surface: DmsTheme.Color.popups.background
    property color accent: DmsTheme.Color.accent
    property string fontFamily: DmsTheme.Style.font.family
    property real fontSize: DmsTheme.Style.font.bodySmall
    horizontalPadding: DmsTheme.Style.spacing.lg
    verticalPadding: DmsTheme.Style.spacing.sm
    property bool bordered: false
    property bool selected: false
    property bool focusable: true
    property string tooltipText: ""
    focusPolicy: focusable ? Qt.StrongFocus : Qt.NoFocus
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(DmsTheme.Style.spacing.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    leftPadding: horizontalPadding
    rightPadding: horizontalPadding
    topPadding: verticalPadding
    bottomPadding: verticalPadding
    opacity: enabled ? 1 : 0.5
    contentItem: Text {
        text: root.text
        textFormat: Text.PlainText
        color: root.selected ? DmsTheme.Color.onAccent : root.foreground
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        radius: DmsTheme.Style.cornerRadius
        color: root.selected ? root.accent : root.hovered || root.visualFocus
            ? DmsTheme.Style.hoverFillFor(root.foreground, root.accent) : "transparent"
        border.width: root.bordered || root.visualFocus ? 1 : 0
        border.color: root.visualFocus || root.selected ? root.accent : DmsTheme.Color.outline
    }
    Controls.ToolTip.visible: hovered && tooltipText !== ""
    Controls.ToolTip.text: tooltipText
    Accessible.name: text
}
