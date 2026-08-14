import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components.Settings.Controls
import qs.Services

FloatingWindow {
    id: root
    required property var barWindow
    property var anchorItem
    required property var appearance
    signal closeRequested
    property string category: Quickshell.env("QS_SETTINGS_PAGE") || "general"
    property string targetSection: ""
    property bool barExpanded: true
    property bool componentsExpanded: true
    property bool widgetsExpanded: category.indexOf("widget.") === 0
    property bool systemExpanded: true
    property string navigationSearch: ""

    function openSection(page: string, section: string): void {
        if (page === "system")
            page = section === "display" ? "display" : "audio";
        else if (page === "widgetSettings") {
            page = widgetCategory(section);
            componentsExpanded = true;
            widgetsExpanded = true;
        }
        targetSection = section || "";
        if (category !== page)
            category = page;
        else if (pageLoader.item && pageLoader.item.hasOwnProperty("targetSection"))
            pageLoader.item.targetSection = targetSection;
    }

    function widgetCategory(widgetId: string): string {
        const routes = {
            "activeWindow": "widget.activeWindow",
            "audio": "widget.audio",
            "clock": "widget.clock",
            "cpuTemperature": "widget.cpuTemperature",
            "cpuUsage": "widget.cpuUsage",
            "gpuTemperature": "widget.gpuTemperature",
            "gpuUsage": "widget.gpuUsage",
            "layout": "widget.layout",
            "media": "widget.media",
            "network": "widget.network",
            "notifications": "widget.notifications",
            "settings": "widget.settings",
            "tags": "widget.tags"
        };
        return routes[widgetId] || "widget.activeWindow";
    }

    function categoryLabel(page: string): string {
        const labels = {
            "general": "General",
            "colors": "Colors",
            "layout": "Layout",
            "components": "Widget layout",
            "widget.activeWindow": "Active window title",
            "widget.audio": "Audio widget",
            "widget.clock": "Clock & date",
            "widget.cpuTemperature": "CPU temperature",
            "widget.cpuUsage": "CPU usage",
            "widget.gpuTemperature": "GPU temperature",
            "widget.gpuUsage": "GPU usage",
            "widget.layout": "Layout widget",
            "widget.media": "Media",
            "widget.network": "Network",
            "widget.notifications": "Notifications",
            "widget.settings": "Settings widget",
            "widget.tags": "Tags",
            "audio": "Audio",
            "display": "Display"
        };
        return labels[page] || "General";
    }

    function buildNavigationItems(): var {
        const searching = navigationSearch.trim().length > 0;
        const items = [
            { "kind": "group", "group": "bar", "label": "Bar Settings", "icon": "󰒓", "landing": "general", "expanded": barExpanded, "level": 0 }
        ];
        if (barExpanded || searching) {
            items.push({ "kind": "page", "id": "general", "label": "General", "icon": "󰒓", "level": 1 });
            items.push({ "kind": "page", "id": "colors", "label": "Colors", "icon": "󰏘", "level": 1 });
            items.push({ "kind": "page", "id": "layout", "label": "Layout", "icon": "󰕰", "level": 1 });
        }

        items.push({ "kind": "group", "group": "components", "label": "Components", "icon": "󰕴", "landing": "components", "expanded": componentsExpanded, "level": 0 });
        if (componentsExpanded || searching) {
            items.push({ "kind": "page", "id": "components", "label": "Widget layout", "icon": "󰕴", "level": 1 });
            items.push({ "kind": "subgroup", "group": "widgets", "label": "Widget settings", "icon": "󰥔", "landing": "widget.activeWindow", "expanded": widgetsExpanded, "level": 1 });
            if (widgetsExpanded || searching) {
                items.push({ "kind": "page", "id": "widget.activeWindow", "label": "Active window title", "icon": "󰖲", "level": 2 });
                items.push({ "kind": "page", "id": "widget.audio", "label": "Audio", "icon": "󰕾", "level": 2 });
                items.push({ "kind": "page", "id": "widget.clock", "label": "Clock & date", "icon": "󰥔", "level": 2 });
                items.push({ "kind": "page", "id": "widget.cpuTemperature", "label": "CPU temperature", "icon": "󰔏", "level": 2 });
                items.push({ "kind": "page", "id": "widget.cpuUsage", "label": "CPU usage", "icon": "󰍛", "level": 2 });
                items.push({ "kind": "page", "id": "widget.gpuTemperature", "label": "GPU temperature", "icon": "󰔏", "level": 2 });
                items.push({ "kind": "page", "id": "widget.gpuUsage", "label": "GPU usage", "icon": "󰢮", "level": 2 });
                items.push({ "kind": "page", "id": "widget.layout", "label": "Layout", "icon": "󰕰", "level": 2 });
                items.push({ "kind": "page", "id": "widget.media", "label": "Media", "icon": "󰝚", "level": 2 });
                items.push({ "kind": "page", "id": "widget.network", "label": "Network", "icon": "󰤨", "level": 2 });
                items.push({ "kind": "page", "id": "widget.notifications", "label": "Notifications", "icon": "󰂚", "level": 2 });
                items.push({ "kind": "page", "id": "widget.settings", "label": "Settings", "icon": "󰒓", "level": 2 });
                items.push({ "kind": "page", "id": "widget.tags", "label": "Tags", "icon": "󰓹", "level": 2 });
            }
        }

        items.push({ "kind": "group", "group": "system", "label": "System", "icon": "󰒋", "landing": "audio", "expanded": systemExpanded, "level": 0 });
        if (systemExpanded || searching) {
            items.push({ "kind": "page", "id": "audio", "label": "Audio", "icon": "󰕾", "level": 1 });
            items.push({ "kind": "page", "id": "display", "label": "Display", "icon": "󰍹", "level": 1 });
        }
        return items;
    }

    readonly property var navigationItems: buildNavigationItems()
    readonly property var visibleNavigationItems: {
        const query = navigationSearch.trim().toLowerCase();
        if (!query.length) return navigationItems;
        return navigationItems.filter(item => item.kind === "page"
                                      && item.label.toLowerCase().indexOf(query) >= 0);
    }

    function activateNavigation(item: var): void {
        if (item.kind === "group") {
            if (item.group === "bar") barExpanded = !barExpanded;
            else if (item.group === "components") componentsExpanded = !componentsExpanded;
            else systemExpanded = !systemExpanded;
            category = item.landing;
            return;
        }
        if (item.kind === "subgroup") {
            widgetsExpanded = !widgetsExpanded;
            category = item.landing;
            return;
        }
        category = item.id;
    }

    function pageSource(): string {
        const base = "Components/Settings/Pages/";
        if (category === "colors") return Quickshell.shellPath(base + "ColorsPage.qml");
        if (category === "layout") return Quickshell.shellPath(base + "LayoutPage.qml");
        if (category === "widget.activeWindow") return Quickshell.shellPath(base + "Widgets/ActiveWindowPage.qml");
        if (category === "widget.audio") return Quickshell.shellPath(base + "Widgets/AudioPage.qml");
        if (category === "widget.clock") return Quickshell.shellPath(base + "Widgets/ClockPage.qml");
        if (category === "widget.cpuTemperature") return Quickshell.shellPath(base + "Widgets/CpuTemperaturePage.qml");
        if (category === "widget.cpuUsage") return Quickshell.shellPath(base + "Widgets/CpuUsagePage.qml");
        if (category === "widget.gpuTemperature") return Quickshell.shellPath(base + "Widgets/GpuTemperaturePage.qml");
        if (category === "widget.gpuUsage") return Quickshell.shellPath(base + "Widgets/GpuUsagePage.qml");
        if (category === "widget.layout") return Quickshell.shellPath(base + "Widgets/LayoutWidgetPage.qml");
        if (category === "widget.media") return Quickshell.shellPath(base + "Widgets/MediaPage.qml");
        if (category === "widget.network") return Quickshell.shellPath(base + "Widgets/NetworkPage.qml");
        if (category === "widget.notifications") return Quickshell.shellPath(base + "Widgets/NotificationsPage.qml");
        if (category === "widget.settings") return Quickshell.shellPath(base + "Widgets/SettingsWidgetPage.qml");
        if (category === "widget.tags") return Quickshell.shellPath(base + "Widgets/TagsPage.qml");
        if (category === "audio" || category === "display" || category === "system")
            return Quickshell.shellPath(base + "SystemPage.qml");
        if (category === "components") return Quickshell.shellPath(base + "ComponentsPage.qml");
        return Quickshell.shellPath(base + "GeneralPage.qml");
    }

    function loadPage(): void {
        const properties = { "appearance": appearance };
        if (category === "audio" || category === "display" || category === "system")
            properties.targetSection = category === "display" ? "display" : "audio";
        pageLoader.setSource(pageSource(), properties);
    }

    onCategoryChanged: loadPage()
    Component.onCompleted: {
        if (category === "system") category = "audio";
        else if (category === "widgetSettings") category = widgetCategory(targetSection);
        else loadPage();
    }

    parentWindow: barWindow
    title: "Mango Quickshell Settings"
    // Keep the controls readable at the smallest size while allowing the
    // window to grow freely. Short pages continue to scroll vertically.
    minimumSize: Qt.size(780, 420)
    implicitWidth: 820
    implicitHeight: 620
    color: "transparent"
    onClosed: root.closeRequested()

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.radius + 3
        color: root.appearance.background
        border.width: 1
        border.color: root.appearance.border

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Rectangle {
                Layout.minimumWidth: 202
                Layout.preferredWidth: 202
                Layout.maximumWidth: 202
                Layout.fillHeight: true
                radius: 13
                color: Qt.darker(root.appearance.surface, 1.13)
                border.width: 1
                border.color: root.appearance.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 38

                        MouseArea {
                            anchors.fill: parent
                            onPressed: root.startSystemMove()
                            onDoubleClicked: root.maximized = !root.maximized
                        }

                        RowLayout {
                            anchors.fill: parent
                            spacing: 9
                            Rectangle {
                                implicitWidth: 28
                                implicitHeight: 28
                                radius: 9
                                color: root.appearance.accent
                                Text {
                                    anchors.centerIn: parent
                                    text: "󰒓"
                                    color: root.appearance.background
                                    font.family: root.appearance.iconFont
                                    font.pixelSize: 14
                                }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text {
                                    text: "Mango Shell"
                                    color: root.appearance.text
                                    font.family: root.appearance.textFont
                                    font.pixelSize: 13
                                    font.weight: Font.DemiBold
                                }
                                Text {
                                    text: "Settings"
                                    color: root.appearance.textMuted
                                    font.family: root.appearance.textFont
                                    font.pixelSize: 9
                                }
                            }
                        }
                    }

                    TextField {
                        id: navigationSearchField
                        Layout.fillWidth: true
                        implicitHeight: 34
                        leftPadding: 31
                        rightPadding: 9
                        text: root.navigationSearch
                        placeholderText: "Search"
                        placeholderTextColor: root.appearance.textMuted
                        color: root.appearance.text
                        selectByMouse: true
                        font.family: root.appearance.textFont
                        font.pixelSize: 11
                        onTextEdited: root.navigationSearch = text
                        background: Rectangle {
                            radius: 10
                            color: root.appearance.background
                            border.width: navigationSearchField.activeFocus ? 1 : 0
                            border.color: root.appearance.accent
                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: "󰍉"
                                color: root.appearance.textMuted
                                font.family: root.appearance.iconFont
                                font.pixelSize: 11
                            }
                        }
                    }

                    ScrollView {
                        id: navigationScroll
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                        ScrollBar.vertical: ScrollBar {
                            width: 4
                            contentItem: Rectangle {
                                implicitWidth: 3
                                radius: 2
                                color: root.appearance.accent
                                opacity: parent.active || parent.hovered ? 0.7 : 0.24
                            }
                        }

                        ColumnLayout {
                            width: navigationScroll.availableWidth
                            spacing: 3

                            Repeater {
                                model: root.visibleNavigationItems
                                delegate: Item {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    implicitHeight: 33

                                    SettingsButton {
                                        anchors.fill: parent
                                        anchors.leftMargin: root.navigationSearch.length ? 0 : parent.modelData.level * 10
                                        text: parent.modelData.kind === "page"
                                              ? `${parent.modelData.icon}  ${parent.modelData.label}`
                                              : `${parent.modelData.expanded ? "▾" : "▸"}  ${parent.modelData.label}`
                                        selected: parent.modelData.kind === "page"
                                                  && root.category === parent.modelData.id
                                        flat: true
                                        appearance: root.appearance
                                        font.pixelSize: parent.modelData.kind === "group" ? 12 : 11
                                        font.weight: parent.modelData.kind === "group" ? Font.DemiBold : Font.Medium
                                        onClicked: root.activateNavigation(parent.modelData)
                                    }
                                }
                            }

                            Text {
                                visible: root.visibleNavigationItems.length === 0
                                Layout.fillWidth: true
                                Layout.topMargin: 12
                                text: "No matching settings"
                                horizontalAlignment: Text.AlignHCenter
                                color: root.appearance.textMuted
                                font.family: root.appearance.textFont
                                font.pixelSize: 10
                            }
                            Item { Layout.fillHeight: true }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: Settings.dirty
                        spacing: 7
                        Rectangle {
                            implicitWidth: 6
                            implicitHeight: 6
                            radius: 3
                            color: root.appearance.accent
                        }
                        Text {
                            Layout.fillWidth: true
                            text: "Unsaved changes"
                            color: root.appearance.textMuted
                            font.family: root.appearance.textFont
                            font.pixelSize: 9
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 15
                color: root.appearance.surface
                border.width: 1
                border.color: root.appearance.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 30

                        MouseArea {
                            anchors.fill: parent
                            onPressed: root.startSystemMove()
                            onDoubleClicked: root.maximized = !root.maximized
                        }

                        RowLayout {
                            anchors.fill: parent
                            Text {
                                Layout.fillWidth: true
                                text: root.categoryLabel(root.category)
                                color: root.appearance.accent
                                font.family: root.appearance.textFont
                                font.pixelSize: 17
                                font.weight: Font.DemiBold
                            }
                            SettingsButton {
                                text: "󰅖"
                                compact: true
                                flat: true
                                appearance: root.appearance
                                onClicked: root.closeRequested()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 1
                        color: root.appearance.border
                        opacity: 0.7
                    }

                    Loader {
                        id: pageLoader
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Connections {
                        target: pageLoader.item
                        ignoreUnknownSignals: true
                        function onOpenWidgetSettings(section) {
                            root.openSection("widgetSettings", section);
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 1
                        color: root.appearance.border
                        opacity: 0.7
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        SettingsButton {
                            text: "󰑐  Defaults"
                            outlined: true
                            appearance: root.appearance
                            onClicked: Settings.restoreDefaults()
                        }
                        Item { Layout.fillWidth: true }
                        SettingsButton {
                            text: "Reset changes"
                            enabled: Settings.dirty
                            outlined: true
                            appearance: root.appearance
                            onClicked: Settings.reset()
                        }
                        SettingsButton {
                            text: "󰆓  Save"
                            selected: true
                            appearance: root.appearance
                            onClicked: Settings.save()
                        }
                    }
                }
            }
        }

        component ResizeArea: MouseArea {
            required property int resizeEdges
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onPressed: root.startSystemResize(resizeEdges)
        }

        ResizeArea {
            resizeEdges: Qt.LeftEdge
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            width: 6
            z: 30
            cursorShape: Qt.SizeHorCursor
        }
        ResizeArea {
            resizeEdges: Qt.RightEdge
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            width: 6
            z: 30
            cursorShape: Qt.SizeHorCursor
        }
        ResizeArea {
            resizeEdges: Qt.TopEdge
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            height: 6
            z: 30
            cursorShape: Qt.SizeVerCursor
        }
        ResizeArea {
            resizeEdges: Qt.BottomEdge
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            height: 6
            z: 30
            cursorShape: Qt.SizeVerCursor
        }
        ResizeArea {
            resizeEdges: Qt.LeftEdge | Qt.TopEdge
            anchors.left: parent.left
            anchors.top: parent.top
            width: 14
            height: 14
            z: 31
            cursorShape: Qt.SizeFDiagCursor
        }
        ResizeArea {
            resizeEdges: Qt.RightEdge | Qt.TopEdge
            anchors.right: parent.right
            anchors.top: parent.top
            width: 14
            height: 14
            z: 31
            cursorShape: Qt.SizeBDiagCursor
        }
        ResizeArea {
            resizeEdges: Qt.LeftEdge | Qt.BottomEdge
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: 14
            height: 14
            z: 31
            cursorShape: Qt.SizeBDiagCursor
        }
        ResizeArea {
            resizeEdges: Qt.RightEdge | Qt.BottomEdge
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 14
            height: 14
            z: 31
            cursorShape: Qt.SizeFDiagCursor
        }
    }
}
