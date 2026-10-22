pragma ComponentBehavior: Bound
import QtQuick
import "theme" as DmsTheme
import "controls" as Ui

Column {
  id: root
  property color foreground: DmsTheme.Color.foreground
  property color urgent: DmsTheme.Color.urgent
  property string fontFamily: DmsTheme.Style.font.family
  property string errorText: ""
  property bool saving: false
  signal saveRequested()
  signal cancelRequested()
  spacing: DmsTheme.Style.spacing.md
  Keys.onEscapePressed: if (!saving) cancelRequested()
  Ui.PanelSeparator { width: parent.width; foreground: root.foreground }
  Text {
    visible: root.errorText !== ""
    width: parent.width
    text: root.errorText
    textFormat: Text.PlainText
    wrapMode: Text.WordWrap
    color: root.urgent
    font.family: root.fontFamily
    font.pixelSize: DmsTheme.Style.font.caption
  }
  Item {
    width: parent.width
    implicitHeight: Math.max(cancelButton.implicitHeight, saveButton.implicitHeight)
    Ui.Button {
      id: cancelButton
      objectName: "cancelSettingsButton"
      text: "Cancel"
      foreground: root.foreground
      fontFamily: root.fontFamily
      focusable: true
      enabled: !root.saving
      onClicked: root.cancelRequested()
    }
    Ui.Button {
      id: saveButton
      objectName: "saveSettingsButton"
      anchors.right: parent.right
      text: root.saving ? "Saving…" : "Save changes"
      foreground: root.foreground
      fontFamily: root.fontFamily
      bordered: true
      selected: true
      focusable: true
      enabled: !root.saving
      onClicked: root.saveRequested()
    }
  }
}
