import QtQuick
import Quickshell
import Quickshell.Io
import "UsageLogic.js" as UsageLogic

Item {
    id: root
    property string target: ""
    required property var panel
    property bool global: false
    function currentPanel() {
        return global ? UsageLogic.preferredPanel() : panel
    }
    IpcHandler {
        target: root.target
        function open(): void {
            root.currentPanel().open()
        }
        function close(): void {
            root.currentPanel().close()
        }
        function show(): void {
            root.currentPanel().open()
        }
        function hide(): void {
            root.currentPanel().close()
        }
        function toggle(): void {
            root.currentPanel().toggle()
        }
        function refresh(): string {
            root.currentPanel().refreshNow()
            return "ok"
        }
        function next(): string {
            root.currentPanel().nextProvider()
            return "ok"
        }
        function limits(): string {
            root.currentPanel().showLimits()
            return "ok"
        }
        function costs(): string {
            root.currentPanel().showCosts()
            return "ok"
        }
        function configureCosts(): string {
            root.currentPanel().showCostSettings()
            return "ok"
        }
        function configure(): string {
            root.currentPanel().showSettings()
            return "ok"
        }
        function status(): string {
            var p = root.currentPanel()
            return JSON.stringify({
                view: p.viewMode,
                opened: p.opened,
                provider: p.provider ? p.provider.id : "",
                source: p.usageBackend.usageSource,
                providerStatus: p.provider ? p.provider.status : "unavailable",
                loading: p.viewMode === "costs" ? p.costsBackend.loading : p.usageBackend.loading,
                error: p.viewMode === "costs" ? p.costsBackend.fetchError : p.usageBackend.fetchError,
                width: p.width,
                height: p.height
            })
        }
        function snapshot(): string {
            var p = root.currentPanel()
            if (!p.opened)
                return "Open the panel first"
            var directory = Quickshell.env("XDG_RUNTIME_DIR")
            if (!directory)
                return "XDG_RUNTIME_DIR is unavailable"
            var path = directory + "/dms-modelusage-panel.png";
            return p.grabToImage(function (result) {
                result.saveToFile(path)
            }) ? path : "Could not capture the panel"
        }
    }
}
