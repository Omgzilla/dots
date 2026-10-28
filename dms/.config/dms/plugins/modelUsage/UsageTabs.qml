pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as Controls
import "theme" as DmsTheme

Controls.TabBar {
  id: root

  property var options: []
  property string value: ""
  property color foreground: DmsTheme.Color.foreground
  property string fontFamily: DmsTheme.Style.font.family
  property real fontSize: DmsTheme.Style.font.bodySmall
  signal changed(string value)

  implicitHeight: DmsTheme.Style.spacing.controlHeight + DmsTheme.Style.spacing.sm
  spacing: DmsTheme.Style.spacing.md
  currentIndex: {
    for (var i = 0; i < options.length; i++)
      if (options[i].value === value) return i
    return -1
  }
  background: Item {}
  onCurrentIndexChanged: {
    if (currentIndex >= 0 && currentIndex < options.length
        && options.some(function(option) { return option.value === root.value })
        && options[currentIndex].value !== value)
      changed(options[currentIndex].value)
  }

  Repeater {
    model: root.options

    Controls.TabButton {
      id: viewTab
      required property var modelData
      text: modelData.label
      width: implicitWidth
      height: root.height
      implicitHeight: root.height
      leftPadding: DmsTheme.Style.spacing.md
      rightPadding: DmsTheme.Style.spacing.md
      topPadding: DmsTheme.Style.spacing.sm
      bottomPadding: DmsTheme.Style.spacing.md
      Accessible.name: text

      contentItem: Text {
        text: viewTab.text
        color: viewTab.checked ? DmsTheme.Color.accent : root.foreground
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        // Reserve bold label widths so changing tabs doesn't move controls.
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
      }

      background: Rectangle {
        color: viewTab.hovered || viewTab.visualFocus
          ? DmsTheme.Style.hoverFillFor(root.foreground, DmsTheme.Color.accent) : "transparent"
        border.width: viewTab.visualFocus ? DmsTheme.Style.spacing.hairline : 0
        border.color: DmsTheme.Color.accent

        Rectangle {
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          height: DmsTheme.Style.space(2)
          visible: viewTab.checked
          color: DmsTheme.Color.accent
        }
      }
    }
  }
}
