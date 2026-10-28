pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Controls as Controls
import Quickshell
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins
import "UsageLogic.js" as UsageLogic

PluginComponent {
    id: root
    layerNamespacePlugin: "modelusage"
    readonly property var providers: modelPanel.providers
    readonly property var provider: modelPanel.provider
    readonly property color barForeground: Theme.widgetTextColor
    readonly property color barIcon: Theme.widgetIconColor
    readonly property int warningThreshold: modelPanel.warningThreshold
    readonly property int criticalThreshold: modelPanel.criticalThreshold
    readonly property bool percentageMode: modelPanel.percentageMode
    readonly property var percentageProviders: modelPanel.percentageProviders
    readonly property bool alarming: modelPanel.alarming
    function barIconUrl(provider) { return modelPanel.barIconUrl(provider) }
    function selectProviderId(id) { modelPanel.viewMode = "limits"; modelPanel.selectProviderId(id) }
    function barReading(provider) {
        var last = modelPanel.lastAccount(provider)
        return modelPanel.proxyMode && last.reading ? last.reading : provider
    }

    // The panel and its collectors live with the widget, even while its visual
    // content is attached to DMS's lazily created popout.
    Item { id: parking; visible: false; width: 420; height: 680 }
    ModelUsagePanel {
        id: modelPanel
        objectName: "modelUsagePanel"
        parent: parking
        anchors.fill: parent
        surfaceLive: root.surfaceLive
        opened: root.interactionActive
        ipcTarget: root.widgetInstanceId ? "dms-modelusage-" + root.widgetInstanceId : "dms-modelusage"
        settings: root.pluginData
        bar: ({vertical: root.isVertical, foreground: Theme.surfaceText,
            urgent: Theme.error, fontFamily: Theme.fontFamily})
        persistSettings: function(values) {
            if (!root.pluginService || !root.pluginService.savePluginData) return false
            for (var key in values) root.pluginService.savePluginData(root.pluginId, key, values[key])
            root.loadPluginData()
            return true
        }
        onOpenRequested: if (!opened) root.triggerPopout()
        onCloseRequested: root.closePopout()
    }

    horizontalBarPill: Component {
        Item {
            implicitWidth: root.percentageMode
                ? percentageRow.implicitWidth : iconRow.implicitWidth
            implicitHeight: root.percentageMode
                ? percentageRow.implicitHeight : iconRow.implicitHeight

            Row {
                id: iconRow
                anchors.centerIn: parent
                visible: !root.percentageMode
                spacing: Theme.spacingXS

                DIcon {
                    name: "data_usage"
                    size: root.iconSize
                    color: root.alarming ? Theme.error : root.barIcon
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                id: percentageRow
                anchors.centerIn: parent
                visible: root.percentageMode
                spacing: Theme.spacingXXS

                Repeater {
                    model: root.percentageProviders

                    delegate: Item {
                        required property var modelData

                        readonly property var reading: root.barReading(modelData)
                        readonly property var remainingValue: UsageLogic.minRemaining(reading)
                        readonly property string remainingText: remainingValue === null
                            ? "—" : Math.round(remainingValue) + "%"
                        readonly property string severity: UsageLogic.severity(
                            reading, root.warningThreshold, root.criticalThreshold)
                        readonly property bool stressed: severity === "warning"
                            || severity === "critical"

                        implicitWidth: mark.width + label.implicitWidth + Theme.spacingS
                        width: implicitWidth
                        height: root.iconSize + Theme.spacingXS

                        Item {
                            id: mark
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: root.iconSize - 6
                            height: width

                            Image {
                                id: markImage
                                anchors.fill: parent
                                source: root.barIconUrl(modelData)
                                sourceSize.width: width * 2
                                sourceSize.height: height * 2
                                fillMode: Image.PreserveAspectFit
                                visible: false
                                layer.enabled: true
                            }

                            MultiEffect {
                                anchors.fill: markImage
                                source: markImage
                                visible: markImage.status === Image.Ready
                                colorization: 1
                                colorizationColor: stressed ? Theme.error : root.barIcon
                            }

                            StyledText {
                                anchors.centerIn: parent
                                visible: markImage.status !== Image.Ready
                                text: UsageLogic.providerMark(String(modelData.id))
                                font.pixelSize: Math.max(1, root.textSize - 2)
                                font.weight: Font.Bold
                                color: stressed ? Theme.error : root.barIcon
                            }
                        }

                        StyledText {
                            id: label
                            objectName: "modelUsagePercentage"
                            anchors.left: mark.right
                            anchors.leftMargin: Theme.spacingXS
                            anchors.verticalCenter: parent.verticalCenter
                            text: remainingText
                            font.pixelSize: root.textSize
                            font.weight: Font.DemiBold
                            color: stressed ? Theme.error : root.barForeground
                        }

                        MouseArea {
                            id: chipMouse
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function(mouse) {
                                if (mouse.button === Qt.MiddleButton) {
                                    modelPanel.nextProvider()
                                    return
                                }
                                root.selectProviderId(String(modelData.id))
                                root.triggerPopout()
                            }
                        }
                        Controls.ToolTip.visible: chipMouse.containsMouse
                        Controls.ToolTip.text: String(modelData.name || modelData.id)
                            + (modelPanel.proxyMode ? "\n" + modelPanel.lastAccountTooltip(modelPanel.lastAccount(modelData)) : "")
                    }
                }
            }
        }
    }

    verticalBarPill: Component {
        DIcon {
            name: "data_usage"
            size: root.iconSize
            color: root.alarming ? Theme.error : root.barIcon
        }
    }


    attachedContent: popoutContent

    popoutContent: Component {
        PopoutComponent {
            id: popup
            headerText: ""
            Item {
                id: viewport
                width: parent.width
                implicitHeight: Math.max(300, Math.min(680,
                    popup.parentPopout && popup.parentPopout.screen
                        ? popup.parentPopout.screen.height - 100 : 680))
                height: implicitHeight
                Component.onCompleted: {
                    modelPanel.parent = viewport
                }
                Component.onDestruction: {
                    if (modelPanel.parent === viewport)
                        modelPanel.parent = parking
                }
            }
        }
    }
    popoutWidth: 460
    popoutHeight: 700
}
