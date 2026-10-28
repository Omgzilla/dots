import QtQuick
import qs.DCommon.Widgets as DCommon
import "../theme" as DmsTheme

DCommon.DTextField {
    property color foreground: DmsTheme.Color.foreground
    property color accent: DmsTheme.Color.accent
    property bool password: false
    property bool selectByMouse: true
    textColor: foreground
    placeholderColor: DmsTheme.Color.dim
    focusedBorderColor: accent
    normalBorderColor: DmsTheme.Color.outline
    backgroundColor: DmsTheme.Color.card
    echoMode: password ? TextInput.Password : TextInput.Normal
    showPasswordToggle: password
    expressive: true
}
