import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components.Common
import qs.Services

PopupWindow {
    id: root
    required property var barWindow
    required property var anchorItem
    required property var appearance
    property string selectedSsid: ""
    signal dismissRequested
    grabFocus: true

    onVisibleChanged: {
        if (visible) {
            NetworkService.refreshDetails();
            NetworkService.scan();
        } else {
            selectedSsid = "";
            passwordInput.text = "";
        }
    }

    anchor.window: barWindow
    anchor.rect.x: Settings.popupX("network", barWindow.width, implicitWidth)
    anchor.rect.y: Settings.edge === "top"
                   ? barWindow.height + 7
                   : -implicitHeight - 7
    implicitWidth: 370
    implicitHeight: 500
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
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "Network"
                    color: root.appearance.text
                    font.family: root.appearance.textFont
                    font.pixelSize: 15
                    font.weight: Font.Medium
                }
                Text {
                    text: NetworkService.connected ? "Connected" : "Offline"
                    color: NetworkService.connected ? root.appearance.accent : root.appearance.textMuted
                    font.family: root.appearance.textFont
                    font.pixelSize: 10
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: details.implicitHeight + 16
                radius: 8
                color: root.appearance.surface

                ColumnLayout {
                    id: details
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 8
                    spacing: 4
                    DetailRow { label: "Type"; value: NetworkService.connectionType; appearance: root.appearance }
                    DetailRow { label: "Interface"; value: NetworkService.interfaceName || "—"; appearance: root.appearance }
                    DetailRow { label: "IPv4"; value: NetworkService.ipv4 || "—"; appearance: root.appearance }
                    DetailRow { label: "IPv6"; value: NetworkService.ipv6 || "—"; appearance: root.appearance }
                    DetailRow { label: "MAC"; value: NetworkService.macAddress || "—"; appearance: root.appearance }
                    DetailRow {
                        label: "Bandwidth"
                        value: `↓ ${NetworkService.formatRate(NetworkService.downloadBytesPerSecond)}   ↑ ${NetworkService.formatRate(NetworkService.uploadBytesPerSecond)}`
                        appearance: root.appearance
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                visible: NetworkService.wifiAvailable
                spacing: 7
                ActionButton {
                    Layout.fillWidth: true
                    text: NetworkService.wifiEnabled ? "󰖩  Wi-Fi on" : "󰖪  Wi-Fi off"
                    selected: NetworkService.wifiEnabled
                    appearance: root.appearance
                    onClicked: NetworkService.toggleWifi()
                }
                ActionButton {
                    implicitWidth: 86
                    text: NetworkService.scanning ? "Scanning…" : "󰑐  Scan"
                    appearance: root.appearance
                    enabled: NetworkService.wifiEnabled
                    onClicked: NetworkService.scan()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                visible: NetworkService.connected
                Text {
                    Layout.fillWidth: true
                    text: NetworkService.wifiConnected
                          ? `${NetworkService.ssid} · ${NetworkService.signalStrength}%`
                          : "Wired connection"
                    color: root.appearance.text
                    elide: Text.ElideRight
                    font.family: root.appearance.textFont
                    font.pixelSize: 11
                }
                ActionButton {
                    implicitWidth: 92
                    text: "Disconnect"
                    appearance: root.appearance
                    onClicked: NetworkService.disconnect()
                }
            }

            Text {
                visible: NetworkService.wifiAvailable && NetworkService.wifiEnabled
                text: "Available Wi-Fi"
                color: root.appearance.textMuted
                font.family: root.appearance.textFont
                font.pixelSize: 10
                font.weight: Font.Medium
            }

            ListView {
                id: networkList
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: NetworkService.wifiAvailable && NetworkService.wifiEnabled
                clip: true
                spacing: 3
                model: NetworkService.wifiNetworks

                delegate: Rectangle {
                    id: networkDelegate
                    required property var modelData
                    width: networkList.width
                    height: 43
                    radius: 7
                    color: networkMouse.containsMouse || root.selectedSsid === modelData.name
                           ? root.appearance.surfaceHover : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 7
                        anchors.rightMargin: 7
                        spacing: 7
                        Text {
                            text: networkDelegate.modelData.signal >= 67 ? "󰤨"
                                  : (networkDelegate.modelData.signal >= 34 ? "󰤥" : "󰤟")
                            color: networkDelegate.modelData.connected ? root.appearance.accent : root.appearance.textMuted
                            font.family: root.appearance.iconFont
                            font.pixelSize: 14
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text {
                                Layout.fillWidth: true
                                text: networkDelegate.modelData.name
                                color: root.appearance.text
                                elide: Text.ElideRight
                                font.family: root.appearance.textFont
                                font.pixelSize: 11
                                font.weight: networkDelegate.modelData.connected ? Font.Medium : Font.Normal
                            }
                            Text {
                                text: networkDelegate.modelData.connected ? "Connected"
                                      : `${networkDelegate.modelData.signal}% · ${networkDelegate.modelData.known ? "Saved" : networkDelegate.modelData.security}`
                                color: root.appearance.textMuted
                                font.family: root.appearance.textFont
                                font.pixelSize: 9
                            }
                        }
                        Text {
                            visible: networkDelegate.modelData.secured
                            text: "󰌾"
                            color: root.appearance.textMuted
                            font.family: root.appearance.iconFont
                            font.pixelSize: 11
                        }
                    }

                    MouseArea {
                        id: networkMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (networkDelegate.modelData.connected) {
                                NetworkService.disconnect();
                            } else if (networkDelegate.modelData.known || !networkDelegate.modelData.secured) {
                                NetworkService.connectWifi(networkDelegate.modelData.name, "");
                            } else {
                                root.selectedSsid = networkDelegate.modelData.name;
                                passwordInput.forceActiveFocus();
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                visible: root.selectedSsid.length > 0
                spacing: 6
                TextField {
                    id: passwordInput
                    Layout.fillWidth: true
                    implicitHeight: 32
                    placeholderText: `Password for ${root.selectedSsid}`
                    echoMode: TextInput.Password
                    color: root.appearance.text
                    placeholderTextColor: root.appearance.textMuted
                    font.family: root.appearance.textFont
                    font.pixelSize: 11
                    onAccepted: connectButton.clicked()
                    background: Rectangle {
                        radius: 7
                        color: root.appearance.surface
                        border.width: passwordInput.activeFocus ? 1 : 0
                        border.color: root.appearance.accent
                    }
                }
                ActionButton {
                    id: connectButton
                    implicitWidth: 76
                    text: "Connect"
                    selected: true
                    appearance: root.appearance
                    onClicked: {
                        if (NetworkService.connectWifi(root.selectedSsid, passwordInput.text)) {
                            root.selectedSsid = "";
                            passwordInput.text = "";
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                visible: NetworkService.connectionError.length > 0
                text: NetworkService.connectionError
                color: root.appearance.urgent
                wrapMode: Text.WordWrap
                font.family: root.appearance.textFont
                font.pixelSize: 10
            }
        }
    }

    component DetailRow: RowLayout {
        required property string label
        required property string value
        required property var appearance
        spacing: 8
        Text {
            Layout.preferredWidth: 70
            text: parent.label
            color: parent.appearance.textMuted
            font.family: parent.appearance.textFont
            font.pixelSize: 10
        }
        Text {
            Layout.fillWidth: true
            text: parent.value
            color: parent.appearance.text
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideMiddle
            font.family: parent.appearance.iconFont
            font.pixelSize: 10
        }
    }

    component ActionButton: Rectangle {
        id: action
        required property string text
        required property var appearance
        property bool selected: false
        signal clicked
        implicitWidth: 74
        implicitHeight: 30
        radius: 7
        opacity: enabled ? 1 : 0.45
        color: selected ? appearance.accent
                        : (actionMouse.containsMouse ? appearance.surfaceHover : appearance.surface)
        Text {
            anchors.centerIn: parent
            text: action.text
            color: action.selected ? action.appearance.background : action.appearance.text
            font.family: action.appearance.textFont
            font.pixelSize: 10
            font.weight: Font.Medium
        }
        MouseArea {
            id: actionMouse
            anchors.fill: parent
            enabled: action.enabled
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: action.clicked()
        }
    }
}
