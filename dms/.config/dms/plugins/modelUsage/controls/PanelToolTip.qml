import QtQuick
import QtQuick.Controls as Controls
import "../theme" as DmsTheme

Controls.ToolTip {
    id: root
    property string fontFamily: DmsTheme.Style.font.family
    delay: 500
    contentItem: Text {
        text: root.text
        color: DmsTheme.Color.foreground
        font.family: root.fontFamily
        font.pixelSize: DmsTheme.Style.font.caption
        wrapMode: Text.WordWrap
    }
    background: BorderSurface { color: DmsTheme.Color.popups.background }
}
