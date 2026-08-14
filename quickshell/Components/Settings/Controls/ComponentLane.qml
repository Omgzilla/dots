import QtQuick
import QtQuick.Layouts
import qs.Services

Rectangle {
    id: root
    required property string section
    required property string title
    required property var appearance
    signal settingsRequested(string widgetId)
    readonly property var widgets: Settings.listFor(section)
    readonly property bool dragInside: {
        ComponentDrag.revision;
        if (!ComponentDrag.active) return false;
        const point = root.mapFromGlobal(ComponentDrag.globalX, ComponentDrag.globalY);
        return point.x >= 0 && point.x <= root.width && point.y >= 0 && point.y <= root.height;
    }

    implicitHeight: Math.max(section === "hidden" ? 58 : 68, content.implicitHeight + 14)
    radius: 9
    color: appearance.background
    border.width: 1
    border.color: root.dragInside ? appearance.accent : appearance.border

    Connections {
        target: ComponentDrag
        function onDropRequested(widgetId, globalX, globalY) {
            const point = root.mapFromGlobal(globalX, globalY);
            if (point.x >= 0 && point.x <= root.width && point.y >= 0 && point.y <= root.height)
                Settings.placeWidgetAt(widgetId, root.section, root.widgets.length);
        }
    }

    ColumnLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 6
        spacing: 4

        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                text: root.title
                color: root.appearance.text
                font.family: root.appearance.textFont
                font.pixelSize: 11
                font.weight: Font.DemiBold
            }
            Text {
                text: root.widgets.length
                color: root.appearance.textMuted
                font.family: root.appearance.iconFont
                font.pixelSize: 10
            }
        }

        Repeater {
            model: root.widgets
            delegate: ComponentCard {
                required property string modelData
                required property int index
                Layout.fillWidth: true
                widgetId: modelData
                section: root.section
                orderIndex: index
                appearance: root.appearance
                onSettingsRequested: widgetId => root.settingsRequested(widgetId)
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.widgets.length === 0
            text: "Drop here"
            color: root.appearance.textMuted
            horizontalAlignment: Text.AlignHCenter
            font.family: root.appearance.textFont
            font.pixelSize: 10
        }
    }
}
