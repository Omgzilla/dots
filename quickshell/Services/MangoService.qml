pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string socketPath: Quickshell.env("MANGO_INSTANCE_SIGNATURE") ?? ""
    readonly property bool available: socketPath.length > 0

    property var outputs: ({})
    property var clients: []

    readonly property var layoutCatalog: [
        { "name": "tile", "symbol": "T", "label": "Tile", "icon": "view_quilt" },
        { "name": "scroller", "symbol": "S", "label": "Scroller", "icon": "view_carousel" },
        { "name": "grid", "symbol": "G", "label": "Grid", "icon": "grid_view" },
        { "name": "monocle", "symbol": "M", "label": "Monocle", "icon": "fullscreen" },
        { "name": "deck", "symbol": "K", "label": "Deck", "icon": "layers" },
        { "name": "center_tile", "symbol": "CT", "label": "Center tile", "icon": "view_compact" },
        { "name": "right_tile", "symbol": "RT", "label": "Right tile", "icon": "view_sidebar" },
        { "name": "vertical_scroller", "symbol": "VS", "label": "Vertical scroller", "icon": "scrollable_header" },
        { "name": "vertical_tile", "symbol": "VT", "label": "Vertical tile", "icon": "clarify" },
        { "name": "vertical_grid", "symbol": "VG", "label": "Vertical grid", "icon": "grid_on" },
        { "name": "vertical_deck", "symbol": "VK", "label": "Vertical deck", "icon": "view_day" },
        { "name": "dwindle", "symbol": "DW", "label": "Dwindle", "icon": "view_quilt" },
        { "name": "fair", "symbol": "F", "label": "Fair", "icon": "view_quilt" },
        { "name": "vertical_fair", "symbol": "VF", "label": "Vertical fair", "icon": "view_quilt" }
    ]

    readonly property var emptyTags: [
        { "index": 1, "is_active": false, "is_urgent": false, "client_count": 0 },
        { "index": 2, "is_active": false, "is_urgent": false, "client_count": 0 },
        { "index": 3, "is_active": false, "is_urgent": false, "client_count": 0 },
        { "index": 4, "is_active": false, "is_urgent": false, "client_count": 0 },
        { "index": 5, "is_active": false, "is_urgent": false, "client_count": 0 },
        { "index": 6, "is_active": false, "is_urgent": false, "client_count": 0 },
        { "index": 7, "is_active": false, "is_urgent": false, "client_count": 0 },
        { "index": 8, "is_active": false, "is_urgent": false, "client_count": 0 },
        { "index": 9, "is_active": false, "is_urgent": false, "client_count": 0 }
    ]

    function parseMonitors(line: string): void {
        if (!line || !line.trim())
            return;

        try {
            const payload = JSON.parse(line);
            if (!Array.isArray(payload.monitors))
                return;

            const next = {};
            for (const monitor of payload.monitors) {
                if (monitor.name)
                    next[monitor.name] = monitor;
            }
            outputs = next;
        } catch (error) {
            console.warn("Mango monitor IPC returned invalid JSON:", error);
        }
    }

    function parseClients(line: string): void {
        if (!line || !line.trim())
            return;

        try {
            const payload = JSON.parse(line);
            if (Array.isArray(payload.clients))
                clients = payload.clients;
        } catch (error) {
            console.warn("Mango client IPC returned invalid JSON:", error);
        }
    }

    function output(name: string): var {
        return outputs[name] ?? null;
    }

    function layoutInfo(symbol: string): var {
        return layoutCatalog.find(layout => layout.symbol === symbol)
            ?? { "name": "", "symbol": symbol || "–", "label": symbol || "Unknown", "icon": "view_quilt" };
    }

    function tagsFor(name: string): var {
        return output(name)?.tags ?? emptyTags;
    }

    function focusedClient(name: string): var {
        return clients.find(client => client.monitor === name && client.is_focused) ?? null;
    }

    function viewTag(outputName: string, tag: int): void {
        if (!available)
            return;
        Quickshell.execDetached(["mmsg", "dispatch", `viewcrossmon,${tag},${outputName}`]);
    }

    function toggleTag(outputName: string, tag: int): void {
        if (!available)
            return;
        // toggleview targets the focused output, which is also where a bar click lands.
        Quickshell.execDetached(["mmsg", "dispatch", `toggleview,${tag}`]);
    }

    function setLayout(outputName: string, layoutName: string): void {
        if (!available || !layoutCatalog.some(layout => layout.name === layoutName))
            return;
        Quickshell.execDetached(["mmsg", "dispatch", `setlayout,${layoutName}`]);
    }

    Process {
        id: monitorWatcher
        running: root.available
        command: ["mmsg", "watch", "all-monitors"]
        stdout: SplitParser {
            onRead: line => root.parseMonitors(line)
        }
        onExited: monitorRestart.start()
    }

    Process {
        id: clientWatcher
        running: root.available
        command: ["mmsg", "watch", "all-clients"]
        stdout: SplitParser {
            onRead: line => root.parseClients(line)
        }
        onExited: clientRestart.start()
    }

    Timer {
        id: monitorRestart
        interval: 1000
        onTriggered: {
            if (root.available)
                monitorWatcher.running = true;
        }
    }

    Timer {
        id: clientRestart
        interval: 1000
        onTriggered: {
            if (root.available)
                clientWatcher.running = true;
        }
    }
}
