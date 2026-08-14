pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root
    property var active: []
    property var history: []
    property var reminders: []
    property int tick: 0
    property bool daemonOwned: false
    property int daemonOwnerPid: 0
    readonly property var popupRecords: {
        tick;
        return Settings.notificationPopups
            ? active.filter(record => record.popupUntil > Date.now()).slice(0, Settings.notificationMaxVisible)
            : [];
    }

    function plain(record: var): var {
        return {
            "key": record.key,
            "appName": record.appName,
            "appIcon": record.appIcon,
            "summary": record.summary,
            "body": record.body,
            "image": record.image,
            "desktopEntry": record.desktopEntry,
            "urgency": record.urgency,
            "timestamp": record.timestamp
        };
    }

    function receive(notification: var): void {
        if (!Settings.notificationsEnabled) {
            notification.dismiss();
            return;
        }
        notification.tracked = true;
        const now = Date.now();
        active = [{
            "key": `${notification.id}-${now}`,
            "notification": notification,
            "appName": notification.appName || notification.desktopEntry || "Application",
            "appIcon": notification.appIcon || "",
            "summary": notification.summary || "Notification",
            "body": notification.body || "",
            "image": notification.image || "",
            "desktopEntry": notification.desktopEntry || "",
            "urgency": notification.urgency,
            "timestamp": now,
            "popupUntil": now + Settings.notificationTimeout * 1000
        }, ...active];
    }

    function removeActive(record: var): void {
        active = active.filter(item => item.key !== record.key);
    }

    function archive(record: var, closeSender: bool): void {
        const saved = plain(record);
        history = [saved, ...history].slice(0, Settings.notificationHistoryLimit);
        saveHistory();
        removeActive(record);
        if (closeSender && record.notification) record.notification.dismiss();
    }

    function activate(record: var): void {
        const defaultAction = record.notification?.actions?.find(action => action.identifier === "default")
                           ?? record.notification?.actions?.[0];
        if (defaultAction) defaultAction.invoke();
        else {
            const entry = DesktopEntries.heuristicLookup(record.desktopEntry || record.appName);
            if (entry) entry.execute();
        }
        if (record.notification) archive(record, true);
    }

    function remind(record: var, minutes: var): void {
        const saved = plain(record);
        const delay = minutes > 0 ? minutes : Settings.notificationReminderMinutes;
        saved.remindAt = Date.now() + delay * 60000;
        reminders = [...reminders, saved];
        removeActive(record);
        if (record.notification) record.notification.dismiss();
    }

    function removeHistory(record: var): void {
        history = history.filter(item => item.key !== record.key);
        saveHistory();
    }

    function clearHistory(): void { history = []; saveHistory(); }
    function dismissAll(): void { for (const record of active.slice()) archive(record, true); }

    function saveHistory(): void {
        historyFile.setText(JSON.stringify({ "history": history }, null, 2) + "\n");
    }

    function refreshDaemonOwner(): void {
        if (!ownerQuery.running)
            ownerQuery.running = true;
    }

    function parseDaemonOwner(text: string): void {
        const match = /u\s+(\d+)/.exec(text.trim());
        daemonOwnerPid = match ? Number(match[1]) : 0;
        daemonOwned = daemonOwnerPid === Quickshell.processId;
    }

    Timer {
        interval: 500
        repeat: true
        running: true
        onTriggered: {
            root.tick++;
            const now = Date.now();
            const due = root.reminders.filter(record => record.remindAt <= now);
            if (due.length) {
                root.reminders = root.reminders.filter(record => record.remindAt > now);
                root.active = [...due.map(record => Object.assign({}, record, {
                    "popupUntil": now + Settings.notificationTimeout * 1000,
                    "timestamp": now,
                    "key": `${record.key}-reminder-${now}`
                })), ...root.active];
            }
        }
    }

    FileView {
        id: historyFile
        path: Quickshell.statePath("notification-history.json")
        preload: true
        blockLoading: true
        blockWrites: true
        atomicWrites: true
        printErrors: false
        onLoaded: {
            try { root.history = (JSON.parse(text()).history ?? []).slice(0, Settings.notificationHistoryLimit); }
            catch (error) { root.history = []; }
        }
    }

    NotificationServer {
        keepOnReload: true
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: false
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true
        inlineReplySupported: true
        onNotification: notification => root.receive(notification)
    }

    Process {
        id: ownerQuery
        command: ["busctl", "--user", "call", "org.freedesktop.DBus", "/org/freedesktop/DBus",
                  "org.freedesktop.DBus", "GetConnectionUnixProcessID", "s", "org.freedesktop.Notifications"]
        stdout: StdioCollector { onStreamFinished: root.parseDaemonOwner(text) }
        onExited: exitCode => {
            if (exitCode !== 0) {
                root.daemonOwnerPid = 0;
                root.daemonOwned = false;
            }
        }
    }

    Timer {
        interval: 3000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refreshDaemonOwner()
    }

    Instantiator {
        model: root.active
        delegate: Connections {
            required property var modelData
            target: modelData.notification ?? null
            enabled: target !== null
            function onClosed(reason) {
                if (root.active.some(record => record.key === modelData.key))
                    root.archive(modelData, false);
            }
        }
    }
}
