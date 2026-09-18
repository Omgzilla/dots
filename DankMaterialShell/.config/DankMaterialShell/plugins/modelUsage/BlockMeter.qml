pragma ComponentBehavior: Bound

import QtQuick
import qs.Common

// Fixed-block quota meter. Only the partial boundary block is overlaid, so
// the track is not rendered twice.
Item {
    id: root

    property real value: 0
    property color fillColor: Theme.primary
    property color trackColor: Theme.withAlpha(fillColor, 0.14)
    property int blockWidth: 5
    property int blockGap: 2
    property real animatedValue: Math.max(0, Math.min(1, value))

    readonly property int pitch: blockWidth + blockGap
    readonly property int blockCount: Math.max(1, Math.floor((width + blockGap) / pitch))
    readonly property real filledBlocks: animatedValue * blockCount
    readonly property int completeBlocks: Math.floor(filledBlocks)
    readonly property real boundaryFraction: filledBlocks - completeBlocks

    implicitHeight: 8
    clip: true

    Behavior on animatedValue {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    Repeater {
        model: root.blockCount

        Rectangle {
            required property int index

            x: index * root.pitch
            width: root.blockWidth
            height: root.height
            radius: Math.min(Theme.cornerRadius, width / 3)
            color: index < root.completeBlocks ? root.fillColor : root.trackColor
        }
    }

    Rectangle {
        visible: root.completeBlocks < root.blockCount && root.boundaryFraction > 0.001
        x: root.completeBlocks * root.pitch
        width: Math.round(root.blockWidth * root.boundaryFraction)
        height: root.height
        radius: Math.min(Theme.cornerRadius, root.blockWidth / 3)
        color: root.fillColor
    }
}
