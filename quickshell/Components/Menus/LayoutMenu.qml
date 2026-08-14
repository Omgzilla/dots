import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Components.Common
import qs.Services

PopupWindow {
    id: root
    required property var barWindow
    required property var barScreen
    required property var appearance
    signal layoutSelected
    signal dismissRequested
    grabFocus: true
    readonly property var output: MangoService.output(barScreen?.name ?? "")

    anchor.window: barWindow
    anchor.rect.x: Settings.popupX("layout", barWindow.width, implicitWidth)
    anchor.rect.y: Settings.edge === "top" ? barWindow.height + 7 : -implicitHeight - 7
    implicitWidth: 350
    implicitHeight: 314
    color: "transparent"

    PopupFocusCloser { popup: root; onDismissRequested: root.dismissRequested() }

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.radius + 2
        color: root.appearance.background
        border.width: 1
        border.color: root.appearance.border

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 11
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "Mango layout"
                    color: root.appearance.text
                    font.family: root.appearance.textFont
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                }
                Text {
                    text: root.output?.layout_symbol ?? ""
                    color: root.appearance.accent
                    font.family: root.appearance.iconFont
                    font.pixelSize: 12
                }
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: 5
                columnSpacing: 5

                Repeater {
                    model: MangoService.layoutCatalog
                    delegate: Rectangle {
                        id: layoutDelegate
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 7
                        color: root.output?.layout_symbol === modelData.symbol
                               ? root.appearance.accent
                               : (layoutMouse.containsMouse ? root.appearance.surfaceHover : root.appearance.surface)

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 9
                            anchors.rightMargin: 9
                            spacing: 8
                            MaterialIcon {
                                name: layoutDelegate.modelData.icon
                                fallback: layoutDelegate.modelData.symbol
                                fallbackFont: root.appearance.iconFont
                                color: root.output?.layout_symbol === layoutDelegate.modelData.symbol
                                       ? root.appearance.background : root.appearance.accent
                                size: 17
                            }
                            Text {
                                Layout.fillWidth: true
                                text: layoutDelegate.modelData.label
                                color: root.output?.layout_symbol === layoutDelegate.modelData.symbol
                                       ? root.appearance.background : root.appearance.text
                                elide: Text.ElideRight
                                font.family: root.appearance.textFont
                                font.pixelSize: 11
                            }
                        }

                        MouseArea {
                            id: layoutMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MangoService.setLayout(root.barScreen.name, layoutDelegate.modelData.name);
                                root.layoutSelected();
                            }
                        }
                    }
                }
            }
        }
    }
}
