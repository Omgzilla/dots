pragma ComponentBehavior: Bound

import QtQuick
import qs.Common
import qs.Widgets
import "UsageLogic.js" as UsageLogic

Item {
    id: root

    property var history: ({ h24: [], d7: [] })
    property string mode: "h24"
    property color foreground: Theme.surfaceText
    property color accent: Theme.primary

    readonly property var values: mode === "d7"
        ? (history ? UsageLogic.listOrEmpty(history.d7) : [])
        : (history ? UsageLogic.listOrEmpty(history.h24) : [])

    implicitHeight: content.implicitHeight

    Column {
        id: content
        width: parent.width
        spacing: Theme.spacingL

        Item {
            width: parent.width
            implicitHeight: Math.max(title.implicitHeight, ranges.implicitHeight)

            StyledText {
                id: title
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "USAGE HISTORY"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Bold
                color: root.foreground
            }

            Row {
                id: ranges
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.spacingXXS

                Repeater {
                    model: [
                        { value: "h24", label: "24H" },
                        { value: "d7", label: "7D" }
                    ]

                    delegate: Rectangle {
                        required property var modelData

                        width: 44
                        height: 28
                        radius: Theme.cornerRadius
                        color: root.mode === modelData.value
                            ? root.accent : Theme.surfaceContainerHigh
                        border.width: 1
                        border.color: root.mode === modelData.value
                            ? root.accent : Theme.outline

                        StyledText {
                            anchors.centerIn: parent
                            text: modelData.label
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                            color: root.mode === modelData.value
                                ? Theme.primaryText : root.foreground
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.mode = modelData.value
                        }
                    }
                }
            }
        }

        Row {
            id: chart
            width: parent.width
            height: 58
            spacing: Theme.spacingXXS

            Repeater {
                model: root.values

                delegate: Item {
                    id: bucket
                    required property var modelData

                    readonly property int segmentHeight: 3
                    readonly property int segmentGap: 2
                    readonly property int segmentPitch: segmentHeight + segmentGap
                    readonly property int segmentCount: Math.max(1, Math.floor(height / segmentPitch))
                    readonly property int filledSegments: Math.ceil(
                        Math.max(0, Math.min(100, Number(modelData) || 0)) / 100 * segmentCount)

                    width: root.values.length > 0
                        ? (chart.width - chart.spacing * (root.values.length - 1)) / root.values.length
                        : 0
                    height: chart.height

                    Repeater {
                        model: bucket.filledSegments

                        Rectangle {
                            required property int index

                            width: bucket.width
                            height: bucket.segmentHeight
                            y: bucket.height - (index + 1) * bucket.segmentPitch
                            radius: Math.min(Theme.cornerRadius, height / 3)
                            color: index === bucket.filledSegments - 1
                                ? root.accent : Theme.withAlpha(root.accent, 0.62)
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: Theme.withAlpha(root.foreground, 0.12)
                    }
                }
            }
        }

        Item {
            width: parent.width
            implicitHeight: Math.max(axisStart.implicitHeight,
                Math.max(axisMiddle.implicitHeight, axisEnd.implicitHeight))

            StyledText {
                id: axisStart
                anchors.left: parent.left
                text: root.mode === "h24" ? "−24h" : "−7d"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceTextMedium
            }

            StyledText {
                id: axisMiddle
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.mode === "h24" ? "−12h" : "−3d"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceTextMedium
            }

            StyledText {
                id: axisEnd
                anchors.right: parent.right
                text: "now"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceTextMedium
            }
        }
    }
}
