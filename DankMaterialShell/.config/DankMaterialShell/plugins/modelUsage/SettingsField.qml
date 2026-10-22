pragma ComponentBehavior: Bound
import QtQuick
import "theme" as DmsTheme
import "controls" as Ui

Ui.TextField {
  id: root
  selectByMouse: true
  background: Ui.BorderSurface {
    color: DmsTheme.Style.controlFill(root.activeFocus, root.hovered, root.foreground, root.accent)
    borderSpec: DmsTheme.Border.controlSpec(root.activeFocus ? "focus" : root.hovered ? "hover-cursor" : "normal", root.foreground, root.accent)
    radius: DmsTheme.Style.space(6)
  }
}
