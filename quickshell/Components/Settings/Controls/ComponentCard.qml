import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services

Rectangle {
    id: root
    required property string widgetId
    required property string section
    required property int orderIndex
    required property var appearance
    readonly property var widget: Settings.widgetInfo(widgetId)
    readonly property bool hidden: section === "hidden"
    readonly property bool hasWidgetSettings: widgetId !== "tray"
    signal settingsRequested(string widgetId)

    implicitHeight: 38
    radius: 7
    color: appearance.surface

    Item {
        id: dragProxy
        width: root.width
        height: root.height
        z: 100
        visible: dragArea.drag.active

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: root.appearance.surfaceHover
            border.width: 1
            border.color: root.appearance.accent
            opacity: 0.82
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: 5
        spacing: 5

        Item {
            Layout.preferredWidth: 18
            Layout.fillHeight: true

            Text {
                anchors.centerIn: parent
                text: "󰆾"
                color: root.appearance.textMuted
                font.family: root.appearance.iconFont
                font.pixelSize: 11
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                cursorShape: Qt.SizeAllCursor
                preventStealing: true
                drag.target: dragProxy
                drag.axis: Drag.XAndYAxis
                drag.smoothed: false
                function globalCenter(): point {
                    return dragProxy.mapToGlobal(dragProxy.width / 2, dragProxy.height / 2);
                }
                onPositionChanged: {
                    if (!drag.active) return;
                    const point = globalCenter();
                    if (!ComponentDrag.active)
                        ComponentDrag.begin(root.widgetId, point.x, point.y);
                    else
                        ComponentDrag.update(point.x, point.y);
                }
                onReleased: {
                    if (ComponentDrag.active) {
                        const point = globalCenter();
                        ComponentDrag.finish(point.x, point.y);
                    }
                    Qt.callLater(() => {
                        if (!dragProxy) return;
                        dragProxy.x = 0;
                        dragProxy.y = 0;
                    });
                }
                onCanceled: {
                    ComponentDrag.cancel();
                    Qt.callLater(() => {
                        if (!dragProxy) return;
                        dragProxy.x = 0;
                        dragProxy.y = 0;
                    });
                }
            }
        }

        Text {
            Layout.preferredWidth: 20
            text: root.widget.icon
            color: root.appearance.accent
            font.family: root.appearance.iconFont
            font.pixelSize: 12
        }
        Text {
            Layout.fillWidth: true
            text: root.widget.label
            color: root.appearance.text
            elide: Text.ElideRight
            font.family: root.appearance.textFont
            font.pixelSize: 11
        }

        SettingsButton {
            visible: root.hasWidgetSettings
            compact: true
            implicitWidth: 25
            implicitHeight: 25
            text: "󰒓"
            appearance: root.appearance
            onClicked: root.settingsRequested(root.widgetId)
        }

        RowLayout {
            spacing: 2
            Repeater {
                model: [
                    { "section": "left", "label": "L" },
                    { "section": "center", "label": "C" },
                    { "section": "right", "label": "R" }
                ]
                delegate: SettingsButton {
                    required property var modelData
                    compact: true
                    implicitWidth: 25
                    implicitHeight: 25
                    text: modelData.label
                    selected: root.section === modelData.section
                    appearance: root.appearance
                    onClicked: Settings.placeWidget(root.widgetId, modelData.section)
                }
            }
        }

        SettingsButton {
            visible: !root.hidden
            compact: true
            implicitWidth: 25
            implicitHeight: 25
            text: "󰁝"
            enabled: root.orderIndex > 0
            appearance: root.appearance
            onClicked: Settings.moveWidget(root.widgetId, -1)
        }
        SettingsButton {
            visible: !root.hidden
            compact: true
            implicitWidth: 25
            implicitHeight: 25
            text: "󰁅"
            enabled: root.orderIndex < Settings.listFor(root.section).length - 1
            appearance: root.appearance
            onClicked: Settings.moveWidget(root.widgetId, 1)
        }
        SettingsButton {
            compact: true
            implicitWidth: 25
            implicitHeight: 25
            text: root.hidden ? "󰈉" : "󰈈"
            appearance: root.appearance
            onClicked: Settings.toggleWidgetVisibility(root.widgetId)
        }
    }
}
