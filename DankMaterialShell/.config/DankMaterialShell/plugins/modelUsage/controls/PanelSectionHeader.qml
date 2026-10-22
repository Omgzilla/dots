import QtQuick
import "../theme" as DmsTheme

Text {
    property color foreground: DmsTheme.Color.foreground
    property string fontFamily: DmsTheme.Style.font.family
    color: DmsTheme.Color.dim
    font.family: fontFamily
    font.pixelSize: DmsTheme.Style.font.caption
    font.weight: Font.DemiBold
    textFormat: Text.PlainText
}
