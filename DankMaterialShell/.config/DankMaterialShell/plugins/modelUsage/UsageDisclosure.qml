pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as Controls
import "theme" as DmsTheme

Controls.AbstractButton {
  id: root

  property color foreground: DmsTheme.Color.foreground
  property string fontFamily: DmsTheme.Style.font.family
  checkable: true
  implicitHeight: Math.max(DmsTheme.Style.spacing.controlHeight, implicitContentHeight + topPadding + bottomPadding)
  implicitWidth: implicitContentWidth + leftPadding + rightPadding
  leftPadding: DmsTheme.Style.spacing.sm
  rightPadding: DmsTheme.Style.spacing.sm
  topPadding: DmsTheme.Style.spacing.sm
  bottomPadding: DmsTheme.Style.spacing.sm
  Accessible.name: text
  Accessible.description: checked ? "Expanded" : "Collapsed"

  contentItem: Text {
    text: (root.checked ? "▾ " : "▸ ") + root.text
    color: root.foreground
    font.family: root.fontFamily
    font.pixelSize: DmsTheme.Style.font.bodySmall
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
  }

  background: Rectangle {
    radius: DmsTheme.Style.space(4)
    color: root.hovered || root.visualFocus
      ? DmsTheme.Style.hoverFillFor(root.foreground, DmsTheme.Color.accent) : "transparent"
    border.width: root.visualFocus ? DmsTheme.Style.spacing.hairline : 0
    border.color: DmsTheme.Color.accent
  }
}
