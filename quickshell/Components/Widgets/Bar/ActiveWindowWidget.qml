import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Services

RowLayout {
    id: root
    required property var barScreen
    required property var appearance
    readonly property var client: MangoService.focusedClient(barScreen?.name ?? "")
    readonly property var entry: client?.appid ? DesktopEntries.heuristicLookup(client.appid) : null
    readonly property string iconSource: {
        const icon = entry?.icon ?? "";
        if (icon.startsWith("/"))
            return `file://${icon}`;
        return icon ? Quickshell.iconPath(icon, true) : "";
    }
    readonly property string shortTitle: entry?.name ?? client?.appid ?? ""
    readonly property string displayTitle: Settings.activeWindowTitleMode === "short"
                                                   ? shortTitle : (client?.title ?? shortTitle)

    visible: client !== null
    spacing: 7

    IconImage {
        implicitWidth: 16
        implicitHeight: 16
        source: root.iconSource
        visible: Settings.activeWindowShowIcon && source.toString().length > 0
    }

    Text {
        Layout.maximumWidth: Settings.activeWindowTitleMode === "short" ? 180 : 420
        text: root.displayTitle
        color: root.appearance.text
        elide: Text.ElideRight
        font.family: root.appearance.textFont
        font.pixelSize: root.appearance.fontSize
        font.weight: root.appearance.fontWeight
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            cursorShape: Settings.widgetCommand("activeWindow") ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: Settings.runWidgetCommand("activeWindow")
        }
    }
}
