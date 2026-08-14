import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Components.Overlays
import qs.Components.Widgets.Bar
import qs.Services

PanelWindow {
    id: root

    property Appearance appearance: Appearance {}
    property bool settingsOpen: Quickshell.env("QS_OPEN_SETTINGS") === "1"
    property var settingsAnchor: null

    anchors {
        top: Settings.edge === "top"
        bottom: Settings.edge === "bottom"
        left: true
        right: true
    }
    margins {
        top: Settings.edge === "top" ? Settings.edgeGap : 0
        bottom: Settings.edge === "bottom" ? Settings.edgeGap : 0
        left: Settings.sideGap
        right: Settings.sideGap
    }

    implicitHeight: Settings.barHeight
    // Reserve exactly the visible panel and its intentional screen-edge gap.
    // Extra pixels here become an invisible gap between tiled clients and bar.
    exclusiveZone: Settings.barHeight + Settings.edgeGap
    color: "transparent"
    focusable: false

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.radius
        color: Qt.rgba(root.appearance.background.r, root.appearance.background.g,
                       root.appearance.background.b, root.appearance.barOpacity)
        border.width: root.appearance.borderWidth
        border.color: root.appearance.border

        WidgetGroup {
            anchors.left: parent.left
            anchors.leftMargin: Settings.contentPadding
            anchors.verticalCenter: parent.verticalCenter
            widgets: Settings.leftWidgets
        }

        WidgetGroup {
            anchors.centerIn: parent
            widgets: Settings.centerWidgets
        }

        WidgetGroup {
            anchors.right: parent.right
            anchors.rightMargin: Settings.contentPadding
            anchors.verticalCenter: parent.verticalCenter
            widgets: Settings.rightWidgets
        }
    }

    QuickSettings {
        id: quickSettings
        barWindow: root
        anchorItem: root.settingsAnchor
        appearance: root.appearance
        visible: root.settingsOpen
        onCloseRequested: root.settingsOpen = false
    }

    NotificationToasts {
        barWindow: root
        barScreen: root.screen
        appearance: root.appearance
    }

    component WidgetGroup: RowLayout {
        required property var widgets
        spacing: Settings.widgetSpacing

        Repeater {
            model: parent.widgets
            delegate: BarWidgetLoader {
                required property string modelData
                widgetName: modelData
                barScreen: root.screen
                barWindow: root
                appearance: root.appearance
                onSettingsRequested: (anchorItem, category, section) => {
                    root.settingsAnchor = anchorItem;
                    root.settingsOpen = true;
                    quickSettings.openSection(category, section);
                }
            }
        }
    }
}
