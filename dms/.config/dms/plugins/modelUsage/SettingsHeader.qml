pragma ComponentBehavior: Bound
import QtQuick
import "theme" as DmsTheme
import "controls" as Ui

Item {
  id: root
  property string title: "Settings"
  property color foreground: DmsTheme.Color.foreground
  property string fontFamily: DmsTheme.Style.font.family
  signal closeRequested()
  signal revealRequested(var item)
  implicitHeight: Math.max(titleLabel.implicitHeight, closeButton.implicitHeight)
  Text {
    id: titleLabel
    anchors.left: parent.left
    anchors.right: closeButton.left
    anchors.verticalCenter: parent.verticalCenter
    text: root.title
    color: root.foreground
    font.family: root.fontFamily
    font.pixelSize: DmsTheme.Style.font.title
    font.bold: true
    elide: Text.ElideRight
  }
  Ui.PanelActionButton {
    id: closeButton
    anchors.right: parent.right
    iconText: "󰅖"
    tooltipText: "Cancel settings"
    foreground: root.foreground
    fontFamily: root.fontFamily
    focusable: true
    onClicked: root.closeRequested()
    onActiveFocusChanged: if (activeFocus) root.revealRequested(closeButton)
  }
}
