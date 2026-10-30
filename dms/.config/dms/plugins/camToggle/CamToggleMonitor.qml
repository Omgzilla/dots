pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

Item {
    id: root

    property var devices: []
    property bool ready: false
    property bool busy: false
    property string queuedAction: ""
    property var queuedIds: []
    readonly property bool actionBusy: (busy && pendingAction !== "status") || queuedAction !== ""
    property bool helperInstalled: false
    property bool helperCompatible: false
    property bool restoreEnabled: false
    property string lastError: ""
    property string pendingAction: "status"
    property bool receivedResult: false
    property bool refreshPending: false
    signal actionFailed(string message)

    function runAction(action, selectedIds) {
        if (busy) {
            if (pendingAction === "status" && action !== "status") {
                queuedAction = action;
                queuedIds = selectedIds || [];
            }
            return;
        }
        queuedAction = "";
        busy = true;
        receivedResult = false;
        pendingAction = action;
        process.command = ["python3", decodeURIComponent(Qt.resolvedUrl("cam_toggle.py").toString().replace(/^file:\/\//, "")), action, JSON.stringify(selectedIds || [])];
        watchdog.restart();
        process.running = true;
    }

    function fail(message) {
        ready = false;
        lastError = message;
        if (pendingAction !== "status")
            actionFailed(message);
    }

    function refreshDevices() {
        if (busy) {
            refreshPending = true;
            return;
        }
        refreshPending = false;
        runAction("status", []);
    }

    Process {
        id: process

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const result = JSON.parse(text);
                    if (!Array.isArray(result.devices))
                        throw new Error("Invalid device list");
                    if (JSON.stringify(root.devices) !== JSON.stringify(result.devices))
                        root.devices = result.devices;
                    root.helperInstalled = !!result.helperInstalled;
                    root.helperCompatible = !!result.helperCompatible;
                    root.restoreEnabled = !!result.restoreEnabled;
                    root.receivedResult = true;
                    root.ready = true;
                    if (root.pendingAction !== "status" || result.error) {
                        root.lastError = result.error || "";
                        if (result.error && root.pendingAction !== "status")
                            root.actionFailed(result.error);
                    }
                    if (result.error && root.pendingAction === "status")
                        root.ready = false;
                } catch (error) {
                    root.fail("Cannot read camera helper output: " + error);
                }
            }
        }
        stderr: StdioCollector {}
        onExited: (exitCode, exitStatus) => {
            watchdog.stop();
            root.busy = false;
            if (!root.receivedResult)
                root.fail("Camera helper could not run. Check that python3 and the plugin files are available.");
            if (root.queuedAction) {
                const action = root.queuedAction;
                const ids = root.queuedIds;
                Qt.callLater(() => root.runAction(action, ids));
            } else if (root.refreshPending) {
                Qt.callLater(root.refreshDevices);
            }
        }
    }

    Timer {
        id: watchdog
        interval: root.pendingAction.indexOf("restore-") === 0 ? 190000 : 25000
        onTriggered: {
            process.running = false;
            root.busy = false;
            root.fail("Camera helper timed out. Refresh to check the current state.");
        }
    }

    Timer {
        id: usbEventDebounce
        interval: 250
        onTriggered: root.refreshDevices()
    }

    Process {
        command: ["udevadm", "monitor", "--udev", "--subsystem-match=usb"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data.indexOf("UDEV") === 0)
                    usbEventDebounce.restart();
            }
        }
    }

    Component.onCompleted: refreshDevices()
}
