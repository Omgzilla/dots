import QtQuick
import QtQuick.Controls as Controls
import "../theme" as DmsTheme

Controls.TextField {
    property color foreground: DmsTheme.Color.foreground
    property color accent: DmsTheme.Color.accent
    property bool password: false
    color: foreground
    placeholderTextColor: DmsTheme.Color.dim
    selectionColor: DmsTheme.Color.accent
    selectedTextColor: DmsTheme.Color.onAccent
    echoMode: password ? TextInput.Password : TextInput.Normal
    selectByMouse: true
    leftPadding: DmsTheme.Style.spacing.md
    rightPadding: DmsTheme.Style.spacing.md
    topPadding: DmsTheme.Style.spacing.md
    bottomPadding: DmsTheme.Style.spacing.md
    implicitHeight: DmsTheme.Style.space(36)
}
