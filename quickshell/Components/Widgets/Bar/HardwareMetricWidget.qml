import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services

Item {
    id: root
    required property var barScreen
    required property var appearance
    required property string widgetId
    required property string widgetLabel
    required property string icon
    required property int metricValue
    required property string suffix
    property int warningThreshold: 80

    readonly property bool available: metricValue >= 0
    readonly property string displayValue: available ? `${metricValue}${suffix}` : "N/A"

    implicitWidth: content.implicitWidth + 12
    implicitHeight: 26

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.itemRadius
        color: metricMouse.containsMouse ? root.appearance.surfaceHover : "transparent"
    }

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 5

        Text {
            text: root.icon
            color: !root.available ? root.appearance.textMuted
                                   : (root.metricValue >= root.warningThreshold
                                      ? root.appearance.urgent : root.appearance.accent)
            font.family: root.appearance.iconFont
            font.pixelSize: 13
        }
        Text {
            text: root.displayValue
            color: root.available ? root.appearance.text : root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: root.appearance.fontSize
            font.weight: root.appearance.fontWeight
        }
    }

    MouseArea {
        id: metricMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                Settings.runWidgetCommand(root.widgetId);
            else
                PerformanceService.refresh();
        }
    }

    ToolTip {
        visible: metricMouse.containsMouse
        delay: 450
        text: root.available ? `${root.widgetLabel}: ${root.displayValue}`
                             : `${root.widgetLabel}: sensor unavailable`
    }
}
