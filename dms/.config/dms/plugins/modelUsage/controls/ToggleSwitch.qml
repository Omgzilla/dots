import QtQuick
import qs.DCommon.Widgets as DCommon
import "../theme" as DmsTheme

DCommon.DToggle {
    id: root
    property color foreground: DmsTheme.Color.foreground
    property bool hasCursor: false
    implicitWidth: trackWidth
    implicitHeight: trackHeight
}
