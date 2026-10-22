pragma ComponentBehavior: Bound
import QtQuick
import "theme" as DmsTheme
import "controls" as Ui

Column {
  id: root
  property string label: "Credential"
  property bool saved: false
  property bool changing: false
  property alias text: field.text
  property string editorObjectName: ""
  property color foreground: DmsTheme.Color.foreground
  property string fontFamily: DmsTheme.Style.font.family
  signal edited(string value)
  signal revealRequested(var item)
  spacing: DmsTheme.Style.spacing.sm

  function reset() { text = ""; changing = false }
  function focusEditor() {
    changing = true
    Qt.callLater(function() { field.forceActiveFocus(); root.revealRequested(field) })
  }

  Row {
    width: parent.width
    visible: root.saved && !root.changing && root.text === ""
    Text {
      width: parent.width - changeButton.width
      anchors.verticalCenter: parent.verticalCenter
      text: root.label + " saved"
      color: DmsTheme.Color.dim
      font.family: root.fontFamily
      font.pixelSize: DmsTheme.Style.font.caption
      wrapMode: Text.WordWrap
    }
    Ui.Button {
      id: changeButton
      text: "Change"
      foreground: root.foreground
      fontFamily: root.fontFamily
      fontSize: DmsTheme.Style.font.bodySmall
      focusable: true
      onClicked: root.focusEditor()
      onActiveFocusChanged: if (activeFocus) root.revealRequested(changeButton)
    }
  }
  SettingsField {
    id: field
    objectName: root.editorObjectName
    width: parent.width
    visible: !root.saved || root.changing || root.text !== ""
    password: true
    maximumLength: 8191
    placeholderText: root.saved ? "New credential · blank keeps the saved value" : root.label
    foreground: root.foreground
    font.family: root.fontFamily
    font.pixelSize: DmsTheme.Style.font.bodySmall
    Accessible.name: root.label
    onTextEdited: root.edited(text)
    onActiveFocusChanged: if (activeFocus) root.revealRequested(field)
  }
}
