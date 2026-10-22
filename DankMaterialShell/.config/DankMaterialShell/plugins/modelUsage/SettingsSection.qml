pragma ComponentBehavior: Bound
import QtQuick
import "theme" as DmsTheme

Column {
  id: root
  property string title: ""
  property string summary: ""
  property alias expanded: disclosure.checked
  property color foreground: DmsTheme.Color.foreground
  property string fontFamily: DmsTheme.Style.font.family
  default property alias content: body.data
  signal revealRequested(var item)
  spacing: DmsTheme.Style.spacing.md
  data: [
    UsageDisclosure {
      id: disclosure
      width: root.width
      text: root.title + (root.summary ? " · " + root.summary : "")
      foreground: root.foreground
      fontFamily: root.fontFamily
      onActiveFocusChanged: if (activeFocus) root.revealRequested(disclosure)
    },
    Column {
      id: body
      visible: disclosure.checked
      width: root.width
      spacing: DmsTheme.Style.spacing.md
    }
  ]
}
