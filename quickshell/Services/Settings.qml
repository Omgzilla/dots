pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property var widgetCatalog: [
        { "id": "tags", "label": "Tags", "icon": "󰓩" },
        { "id": "layout", "label": "Layout", "icon": "󰕰" },
        { "id": "activeWindow", "label": "Active window", "icon": "󰖯" },
        { "id": "tray", "label": "System tray", "icon": "󰇙" },
        { "id": "cpuUsage", "label": "CPU usage", "icon": "󰍛" },
        { "id": "cpuTemperature", "label": "CPU temperature", "icon": "󰔏" },
        { "id": "gpuUsage", "label": "GPU usage", "icon": "󰢮" },
        { "id": "gpuTemperature", "label": "GPU temperature", "icon": "󰔏" },
        { "id": "network", "label": "Network", "icon": "󰖩" },
        { "id": "audio", "label": "Audio", "icon": "󰕾" },
        { "id": "notifications", "label": "Notifications", "icon": "󰂚" },
        { "id": "media", "label": "Media", "icon": "󰎆" },
        { "id": "clock", "label": "Clock", "icon": "󰥔" },
        { "id": "settings", "label": "Quick settings", "icon": "󰒓" }
    ]

    property alias edge: adapter.edge
    property alias textFont: adapter.textFont
    property alias fontSize: adapter.fontSize
    property alias fontWeight: adapter.fontWeight
    property alias barHeight: adapter.barHeight
    property alias edgeGap: adapter.edgeGap
    property alias sideGap: adapter.sideGap
    property alias contentPadding: adapter.contentPadding
    property alias widgetSpacing: adapter.widgetSpacing
    property alias radius: adapter.radius
    property alias background: adapter.background
    property alias surface: adapter.surface
    property alias surfaceHover: adapter.surfaceHover
    property alias border: adapter.border
    property alias text: adapter.text
    property alias textMuted: adapter.textMuted
    property alias accent: adapter.accent
    property alias urgent: adapter.urgent
    property alias colorPalette: adapter.colorPalette
    property alias leftWidgets: adapter.leftWidgets
    property alias centerWidgets: adapter.centerWidgets
    property alias rightWidgets: adapter.rightWidgets
    property alias widgetCommands: adapter.widgetCommands
    property alias clockFormat: adapter.clockFormat
    property alias showDate: adapter.showDate
    property alias dateFormat: adapter.dateFormat
    property alias clockDateSeparator: adapter.clockDateSeparator
    property alias borderWidth: adapter.borderWidth
    property alias barOpacity: adapter.barOpacity
    property alias tagStyle: adapter.tagStyle
    property alias tagLabelMode: adapter.tagLabelMode
    property alias tagShowEmpty: adapter.tagShowEmpty
    property alias tagShowIndicators: adapter.tagShowIndicators
    property alias tagActiveWidth: adapter.tagActiveWidth
    property alias tagInactiveWidth: adapter.tagInactiveWidth
    property alias tagHeight: adapter.tagHeight
    property alias tagSpacing: adapter.tagSpacing
    property alias tagRadius: adapter.tagRadius
    property alias tagInactiveOpacity: adapter.tagInactiveOpacity
    property alias tagIndicatorPosition: adapter.tagIndicatorPosition
    property alias tagActiveIndicatorWidth: adapter.tagActiveIndicatorWidth
    property alias tagOccupiedIndicatorWidth: adapter.tagOccupiedIndicatorWidth
    property alias tagIndicatorHeight: adapter.tagIndicatorHeight
    property alias activeWindowShowIcon: adapter.activeWindowShowIcon
    property alias activeWindowTitleMode: adapter.activeWindowTitleMode
    property alias calendarShowWeekNumbers: adapter.calendarShowWeekNumbers
    property alias calendarFirstDay: adapter.calendarFirstDay
    property alias audioShowDeviceName: adapter.audioShowDeviceName
    property alias hiddenAudioOutputs: adapter.hiddenAudioOutputs
    property alias hiddenAudioInputs: adapter.hiddenAudioInputs
    property alias notificationsEnabled: adapter.notificationsEnabled
    property alias notificationPopups: adapter.notificationPopups
    property alias notificationWidth: adapter.notificationWidth
    property alias notificationTimeout: adapter.notificationTimeout
    property alias notificationMaxVisible: adapter.notificationMaxVisible
    property alias notificationShowIcon: adapter.notificationShowIcon
    property alias notificationShowBody: adapter.notificationShowBody
    property alias notificationCompact: adapter.notificationCompact
    property alias notificationOpacity: adapter.notificationOpacity
    property alias notificationRadius: adapter.notificationRadius
    property alias notificationBorderWidth: adapter.notificationBorderWidth
    property alias notificationHistoryLimit: adapter.notificationHistoryLimit
    property alias notificationReminderMinutes: adapter.notificationReminderMinutes
    property alias notificationPosition: adapter.notificationPosition
    property bool ready: false
    property bool dirty: false
    property bool applyingSnapshot: false
    property var savedSnapshot: ({})
    property var lastVisibleSections: ({})

    function snapshot(): var {
        return {
            "edge": edge,
            "textFont": textFont,
            "fontSize": fontSize,
            "fontWeight": fontWeight,
            "barHeight": barHeight,
            "edgeGap": edgeGap,
            "sideGap": sideGap,
            "contentPadding": contentPadding,
            "widgetSpacing": widgetSpacing,
            "radius": radius,
            "background": background,
            "surface": surface,
            "surfaceHover": surfaceHover,
            "border": border,
            "text": text,
            "textMuted": textMuted,
            "accent": accent,
            "urgent": urgent,
            "colorPalette": colorPalette,
            "leftWidgets": leftWidgets.slice(),
            "centerWidgets": centerWidgets.slice(),
            "rightWidgets": rightWidgets.slice(),
            "widgetCommands": Object.assign({}, widgetCommands),
            "clockFormat": clockFormat,
            "showDate": showDate,
            "dateFormat": dateFormat,
            "clockDateSeparator": clockDateSeparator,
            "borderWidth": borderWidth,
            "barOpacity": barOpacity,
            "tagStyle": tagStyle,
            "tagLabelMode": tagLabelMode,
            "tagShowEmpty": tagShowEmpty,
            "tagShowIndicators": tagShowIndicators,
            "tagActiveWidth": tagActiveWidth,
            "tagInactiveWidth": tagInactiveWidth,
            "tagHeight": tagHeight,
            "tagSpacing": tagSpacing,
            "tagRadius": tagRadius,
            "tagInactiveOpacity": tagInactiveOpacity,
            "tagIndicatorPosition": tagIndicatorPosition,
            "tagActiveIndicatorWidth": tagActiveIndicatorWidth,
            "tagOccupiedIndicatorWidth": tagOccupiedIndicatorWidth,
            "tagIndicatorHeight": tagIndicatorHeight,
            "activeWindowShowIcon": activeWindowShowIcon,
            "activeWindowTitleMode": activeWindowTitleMode,
            "calendarShowWeekNumbers": calendarShowWeekNumbers,
            "calendarFirstDay": calendarFirstDay,
            "audioShowDeviceName": audioShowDeviceName,
            "hiddenAudioOutputs": hiddenAudioOutputs.slice(),
            "hiddenAudioInputs": hiddenAudioInputs.slice(),
            "notificationsEnabled": notificationsEnabled,
            "notificationPopups": notificationPopups,
            "notificationWidth": notificationWidth,
            "notificationTimeout": notificationTimeout,
            "notificationMaxVisible": notificationMaxVisible,
            "notificationShowIcon": notificationShowIcon,
            "notificationShowBody": notificationShowBody,
            "notificationCompact": notificationCompact,
            "notificationOpacity": notificationOpacity,
            "notificationRadius": notificationRadius,
            "notificationBorderWidth": notificationBorderWidth,
            "notificationHistoryLimit": notificationHistoryLimit,
            "notificationReminderMinutes": notificationReminderMinutes,
            "notificationPosition": notificationPosition
        };
    }

    function applySnapshot(value: var): void {
        if (!value) return;
        applyingSnapshot = true;
        edge = value.edge;
        textFont = value.textFont ?? textFont;
        fontSize = value.fontSize ?? fontSize;
        fontWeight = value.fontWeight ?? fontWeight;
        barHeight = value.barHeight;
        edgeGap = value.edgeGap;
        sideGap = value.sideGap;
        contentPadding = value.contentPadding;
        widgetSpacing = value.widgetSpacing;
        radius = value.radius;
        background = value.background;
        surface = value.surface;
        surfaceHover = value.surfaceHover;
        border = value.border;
        text = value.text;
        textMuted = value.textMuted;
        accent = value.accent;
        urgent = value.urgent;
        colorPalette = value.colorPalette ?? colorPalette;
        leftWidgets = value.leftWidgets.slice();
        centerWidgets = value.centerWidgets.slice();
        rightWidgets = value.rightWidgets.slice();
        widgetCommands = Object.assign({}, value.widgetCommands ?? widgetCommands);
        clockFormat = value.clockFormat ?? clockFormat;
        showDate = value.showDate ?? showDate;
        dateFormat = value.dateFormat ?? dateFormat;
        clockDateSeparator = value.clockDateSeparator ?? clockDateSeparator;
        borderWidth = value.borderWidth ?? borderWidth;
        barOpacity = value.barOpacity ?? barOpacity;
        tagStyle = value.tagStyle ?? tagStyle;
        tagLabelMode = value.tagLabelMode ?? tagLabelMode;
        tagShowEmpty = value.tagShowEmpty ?? tagShowEmpty;
        tagShowIndicators = value.tagShowIndicators ?? tagShowIndicators;
        tagActiveWidth = value.tagActiveWidth ?? tagActiveWidth;
        tagInactiveWidth = value.tagInactiveWidth ?? tagInactiveWidth;
        tagHeight = value.tagHeight ?? tagHeight;
        tagSpacing = value.tagSpacing ?? tagSpacing;
        tagRadius = value.tagRadius ?? tagRadius;
        tagInactiveOpacity = value.tagInactiveOpacity ?? tagInactiveOpacity;
        tagIndicatorPosition = value.tagIndicatorPosition ?? tagIndicatorPosition;
        tagActiveIndicatorWidth = value.tagActiveIndicatorWidth ?? tagActiveIndicatorWidth;
        tagOccupiedIndicatorWidth = value.tagOccupiedIndicatorWidth ?? tagOccupiedIndicatorWidth;
        tagIndicatorHeight = value.tagIndicatorHeight ?? tagIndicatorHeight;
        activeWindowShowIcon = value.activeWindowShowIcon ?? activeWindowShowIcon;
        activeWindowTitleMode = value.activeWindowTitleMode ?? activeWindowTitleMode;
        calendarShowWeekNumbers = value.calendarShowWeekNumbers ?? calendarShowWeekNumbers;
        calendarFirstDay = value.calendarFirstDay ?? calendarFirstDay;
        audioShowDeviceName = value.audioShowDeviceName ?? audioShowDeviceName;
        hiddenAudioOutputs = (value.hiddenAudioOutputs ?? hiddenAudioOutputs).slice();
        hiddenAudioInputs = (value.hiddenAudioInputs ?? hiddenAudioInputs).slice();
        notificationsEnabled = value.notificationsEnabled ?? notificationsEnabled;
        notificationPopups = value.notificationPopups ?? notificationPopups;
        notificationWidth = value.notificationWidth ?? notificationWidth;
        notificationTimeout = value.notificationTimeout ?? notificationTimeout;
        notificationMaxVisible = value.notificationMaxVisible ?? notificationMaxVisible;
        notificationShowIcon = value.notificationShowIcon ?? notificationShowIcon;
        notificationShowBody = value.notificationShowBody ?? notificationShowBody;
        notificationCompact = value.notificationCompact ?? notificationCompact;
        notificationOpacity = value.notificationOpacity ?? notificationOpacity;
        notificationRadius = value.notificationRadius ?? notificationRadius;
        notificationBorderWidth = value.notificationBorderWidth ?? notificationBorderWidth;
        notificationHistoryLimit = value.notificationHistoryLimit ?? notificationHistoryLimit;
        notificationReminderMinutes = value.notificationReminderMinutes ?? notificationReminderMinutes;
        notificationPosition = value.notificationPosition ?? notificationPosition;
        applyingSnapshot = false;
    }

    function captureSaved(): void {
        savedSnapshot = snapshot();
        dirty = false;
    }

    function save(): void {
        const current = snapshot();
        settingsFile.setText(JSON.stringify(current, null, 2) + "\n");
        savedSnapshot = current;
        dirty = false;
    }

    function reset(): void {
        applySnapshot(savedSnapshot);
        dirty = false;
    }

    function sectionFor(widget: string): string {
        if (leftWidgets.includes(widget)) return "left";
        if (centerWidgets.includes(widget)) return "center";
        if (rightWidgets.includes(widget)) return "right";
        return "hidden";
    }

    function widgetInfo(widget: string): var {
        return widgetCatalog.find(entry => entry.id === widget) ?? {
            "id": widget, "label": widget, "icon": "󰘳"
        };
    }

    function hiddenWidgets(): var {
        return widgetCatalog.filter(entry => sectionFor(entry.id) === "hidden");
    }

    function listFor(section: string): var {
        if (section === "left") return leftWidgets;
        if (section === "center") return centerWidgets;
        if (section === "right") return rightWidgets;
        if (section === "hidden") return hiddenWidgets().map(entry => entry.id);
        return [];
    }

    function setList(section: string, value: var): void {
        if (section === "left") leftWidgets = value;
        else if (section === "center") centerWidgets = value;
        else if (section === "right") rightWidgets = value;
    }

    function popupX(widget: string, windowWidth: real, popupWidth: real): real {
        const section = sectionFor(widget);
        if (section === "left") return contentPadding;
        if (section === "right") return Math.max(contentPadding, windowWidth - popupWidth - contentPadding);
        return Math.max(contentPadding, (windowWidth - popupWidth) / 2);
    }

    function widgetCommand(widget: string): string {
        return widgetCommands[widget] ?? "";
    }

    function setWidgetCommand(widget: string, command: string): void {
        const next = Object.assign({}, widgetCommands);
        next[widget] = command.trim();
        widgetCommands = next;
    }

    function runWidgetCommand(widget: string): bool {
        const command = widgetCommand(widget).trim();
        if (!command) return false;
        Quickshell.execDetached(["sh", "-lc", command]);
        return true;
    }

    function placeWidget(widget: string, section: string): void {
        placeWidgetAt(widget, section, -1);
    }

    function placeWidgetAt(widget: string, section: string, index: int): void {
        const previous = sectionFor(widget);
        if (previous !== "hidden") {
            const remembered = Object.assign({}, lastVisibleSections);
            remembered[widget] = previous;
            lastVisibleSections = remembered;
        }
        leftWidgets = leftWidgets.filter(item => item !== widget);
        centerWidgets = centerWidgets.filter(item => item !== widget);
        rightWidgets = rightWidgets.filter(item => item !== widget);
        if (section !== "hidden") {
            const target = listFor(section).slice();
            const insertion = index < 0 ? target.length : Math.max(0, Math.min(target.length, index));
            target.splice(insertion, 0, widget);
            setList(section, target);
        }
    }

    function toggleWidgetVisibility(widget: string): void {
        const section = sectionFor(widget);
        if (section === "hidden")
            placeWidget(widget, lastVisibleSections[widget] ?? "right");
        else
            placeWidget(widget, "hidden");
    }

    function moveWidget(widget: string, direction: int): void {
        const section = sectionFor(widget);
        if (section === "hidden") return;
        const items = listFor(section).slice();
        const from = items.indexOf(widget);
        const to = Math.max(0, Math.min(items.length - 1, from + direction));
        if (from === to) return;
        items.splice(from, 1);
        items.splice(to, 0, widget);
        setList(section, items);
    }

    function restoreDefaults(): void {
        applySnapshot({
            "edge": "top", "textFont": "Adwaita Sans", "fontSize": 12, "fontWeight": 50,
            "barHeight": 38, "edgeGap": 8, "sideGap": 10,
            "contentPadding": 7, "widgetSpacing": 7, "radius": 11,
            "background": "#e611151c", "surface": "#ff1a2029",
            "surfaceHover": "#ff242c38", "border": "#ff303947",
            "text": "#ffe6edf3", "textMuted": "#ff8b98a8",
            "accent": "#ff8ab4f8", "urgent": "#ffff7b72",
            "colorPalette": "default",
            "leftWidgets": ["tags", "layout", "activeWindow"],
            "centerWidgets": ["clock", "media"],
            "rightWidgets": ["tray", "cpuUsage", "cpuTemperature", "gpuUsage", "gpuTemperature",
                             "network", "audio", "notifications", "settings"],
            "widgetCommands": {},
            "clockFormat": "HH:mm",
            "showDate": false,
            "dateFormat": "ddd d MMM",
            "clockDateSeparator": "  ",
            "borderWidth": 1,
            "barOpacity": 90,
            "tagStyle": "pill",
            "tagLabelMode": "number",
            "tagShowEmpty": true,
            "tagShowIndicators": true,
            "tagActiveWidth": 31,
            "tagInactiveWidth": 25,
            "tagHeight": 26,
            "tagSpacing": 2,
            "tagRadius": 8,
            "tagInactiveOpacity": 100,
            "tagIndicatorPosition": "bottom",
            "tagActiveIndicatorWidth": 9,
            "tagOccupiedIndicatorWidth": 4,
            "tagIndicatorHeight": 2,
            "activeWindowShowIcon": true,
            "activeWindowTitleMode": "long",
            "calendarShowWeekNumbers": true,
            "calendarFirstDay": "monday",
            "audioShowDeviceName": true,
            "hiddenAudioOutputs": [],
            "hiddenAudioInputs": [],
            "notificationsEnabled": true,
            "notificationPopups": true,
            "notificationWidth": 380,
            "notificationTimeout": 6,
            "notificationMaxVisible": 4,
            "notificationShowIcon": true,
            "notificationShowBody": true,
            "notificationCompact": false,
            "notificationOpacity": 96,
            "notificationRadius": 10,
            "notificationBorderWidth": 1,
            "notificationHistoryLimit": 100,
            "notificationReminderMinutes": 15,
            "notificationPosition": "right"
        });
        dirty = true;
    }

    FileView {
        id: settingsFile
        path: Quickshell.shellPath("settings.json")
        preload: true
        blockLoading: true
        blockWrites: true
        watchChanges: false
        atomicWrites: true
        printErrors: false
        onAdapterUpdated: {
            if (!root.applyingSnapshot)
                root.dirty = true;
        }
        onLoaded: {
            root.captureSaved();
            root.ready = true;
        }
        onSaved: {
            root.captureSaved();
            root.ready = true;
        }
        onLoadFailed: error => {
            if (error === 2)
                root.save();
            else {
                root.captureSaved();
                root.ready = true;
            }
        }

        JsonAdapter {
            id: adapter
            property string edge: "top"
            property string textFont: "Adwaita Sans"
            property int fontSize: 12
            property int fontWeight: 50
            property int barHeight: 38
            property int edgeGap: 8
            property int sideGap: 10
            property int contentPadding: 7
            property int widgetSpacing: 7
            property int radius: 11
            property string background: "#e611151c"
            property string surface: "#ff1a2029"
            property string surfaceHover: "#ff242c38"
            property string border: "#ff303947"
            property string text: "#ffe6edf3"
            property string textMuted: "#ff8b98a8"
            property string accent: "#ff8ab4f8"
            property string urgent: "#ffff7b72"
            property string colorPalette: "default"
            property var leftWidgets: ["tags", "layout", "activeWindow"]
            property var centerWidgets: ["clock", "media"]
            property var rightWidgets: ["tray", "cpuUsage", "cpuTemperature", "gpuUsage",
                                        "gpuTemperature", "network", "audio", "notifications", "settings"]
            property var widgetCommands: ({})
            property string clockFormat: "HH:mm"
            property bool showDate: false
            property string dateFormat: "ddd d MMM"
            property string clockDateSeparator: "  "
            property int borderWidth: 1
            property int barOpacity: 90
            property string tagStyle: "pill"
            property string tagLabelMode: "number"
            property bool tagShowEmpty: true
            property bool tagShowIndicators: true
            property int tagActiveWidth: 31
            property int tagInactiveWidth: 25
            property int tagHeight: 26
            property int tagSpacing: 2
            property int tagRadius: 8
            property int tagInactiveOpacity: 100
            property string tagIndicatorPosition: "bottom"
            property int tagActiveIndicatorWidth: 9
            property int tagOccupiedIndicatorWidth: 4
            property int tagIndicatorHeight: 2
            property bool activeWindowShowIcon: true
            property string activeWindowTitleMode: "long"
            property bool calendarShowWeekNumbers: true
            property string calendarFirstDay: "monday"
            property bool audioShowDeviceName: true
            property var hiddenAudioOutputs: []
            property var hiddenAudioInputs: []
            property bool notificationsEnabled: true
            property bool notificationPopups: true
            property int notificationWidth: 380
            property int notificationTimeout: 6
            property int notificationMaxVisible: 4
            property bool notificationShowIcon: true
            property bool notificationShowBody: true
            property bool notificationCompact: false
            property int notificationOpacity: 96
            property int notificationRadius: 10
            property int notificationBorderWidth: 1
            property int notificationHistoryLimit: 100
            property int notificationReminderMinutes: 15
            property string notificationPosition: "right"
        }
    }
}
