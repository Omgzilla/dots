pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

Singleton {
    id: root

    readonly property var devices: Networking.devices?.values ?? []
    readonly property var wifiDevice: devices.find(device => device.type === DeviceType.Wifi) ?? null
    readonly property var wiredDevice: devices.find(device => device.type === DeviceType.Wired) ?? null
    readonly property var connectedWifi: wifiDevice?.networks?.values?.find(network => network.connected) ?? null
    readonly property bool wiredConnected: wiredDevice?.connected ?? false
    readonly property bool wifiConnected: connectedWifi !== null
    readonly property bool connected: wiredConnected || wifiConnected
    readonly property var activeDevice: wiredConnected ? wiredDevice : (wifiConnected ? wifiDevice : (wifiDevice ?? wiredDevice))
    readonly property string interfaceName: activeDevice?.name ?? ""
    readonly property string macAddress: activeDevice?.address ?? ""
    readonly property string ssid: connectedWifi?.name ?? ""
    readonly property int signalStrength: Math.round((connectedWifi?.signalStrength ?? 0) * 100)
    readonly property string connectionType: wiredConnected ? "Ethernet" : (wifiConnected ? "Wi-Fi" : "Disconnected")
    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property bool wifiAvailable: wifiDevice !== null
    readonly property bool scanning: wifiDevice?.scannerEnabled ?? false

    property string ipv4: ""
    property string ipv6: ""
    property real downloadBytesPerSecond: 0
    property real uploadBytesPerSecond: 0
    property double previousRx: -1
    property double previousTx: -1
    property double previousSampleTime: 0
    property string connectionError: ""
    property var pendingNetwork: null

    readonly property var wifiNetworks: {
        const result = [];
        const seen = new Set();
        for (const network of wifiDevice?.networks?.values ?? []) {
            if (!network?.name || seen.has(network.name)) continue;
            seen.add(network.name);
            result.push({
                "name": network.name,
                "signal": Math.round((network.signalStrength ?? 0) * 100),
                "secured": network.security !== WifiSecurityType.Open,
                "security": WifiSecurityType.toString(network.security),
                "known": network.known,
                "connected": network.connected
            });
        }
        result.sort((a, b) => b.signal - a.signal);
        return result;
    }

    function networkObject(name: string): var {
        return wifiDevice?.networks?.values?.find(network => network.name === name) ?? null;
    }

    function toggleWifi(): void {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    function scan(): void {
        if (wifiDevice && Networking.wifiEnabled) {
            wifiDevice.scannerEnabled = true;
            scanStop.restart();
        }
    }

    function connectWifi(name: string, password: string): bool {
        const network = networkObject(name);
        connectionError = "";
        if (!network) {
            connectionError = "Network is no longer available";
            return false;
        }
        if (network.connected) {
            wifiDevice.disconnect();
            return true;
        }
        if (network.known || network.security === WifiSecurityType.Open) {
            network.connect();
            return true;
        }
        if (!password) {
            connectionError = "Enter the Wi-Fi password";
            return false;
        }
        if (network.security !== WifiSecurityType.WpaPsk
                && network.security !== WifiSecurityType.Wpa2Psk
                && network.security !== WifiSecurityType.Sae
                && network.security !== WifiSecurityType.StaticWep) {
            connectionError = "This network requires enterprise authentication; use your system network settings";
            return false;
        }
        pendingNetwork = network;
        network.connectWithPsk(password);
        return true;
    }

    function disconnect(): void {
        if (wiredConnected) wiredDevice.disconnect();
        else if (wifiConnected) wifiDevice.disconnect();
    }

    function refreshDetails(): void {
        if (!interfaceName) {
            ipv4 = "";
            ipv6 = "";
            downloadBytesPerSecond = 0;
            uploadBytesPerSecond = 0;
            return;
        }
        if (!addressProcess.running) {
            addressProcess.command = ["ip", "-j", "address", "show", "dev", interfaceName];
            addressProcess.running = true;
        }
        if (!bandwidthProcess.running) {
            bandwidthProcess.command = ["cat",
                `/sys/class/net/${interfaceName}/statistics/rx_bytes`,
                `/sys/class/net/${interfaceName}/statistics/tx_bytes`];
            bandwidthProcess.running = true;
        }
    }

    function parseAddresses(text: string): void {
        try {
            const device = JSON.parse(text)[0];
            const addresses = device?.addr_info ?? [];
            ipv4 = addresses.find(address => address.family === "inet")?.local ?? "";
            ipv6 = addresses.find(address => address.family === "inet6" && address.scope === "global")?.local ?? "";
        } catch (error) {
            ipv4 = "";
            ipv6 = "";
        }
    }

    function parseBandwidth(text: string): void {
        const values = text.trim().split(/\s+/).map(value => Number(value));
        if (values.length < 2 || !Number.isFinite(values[0]) || !Number.isFinite(values[1])) return;
        const now = Date.now();
        if (previousRx >= 0 && previousSampleTime > 0) {
            const seconds = Math.max(0.1, (now - previousSampleTime) / 1000);
            downloadBytesPerSecond = Math.max(0, (values[0] - previousRx) / seconds);
            uploadBytesPerSecond = Math.max(0, (values[1] - previousTx) / seconds);
        }
        previousRx = values[0];
        previousTx = values[1];
        previousSampleTime = now;
    }

    function formatRate(bytes: real): string {
        if (bytes >= 1000000000) return `${(bytes / 1000000000).toFixed(1)} GB/s`;
        if (bytes >= 1000000) return `${(bytes / 1000000).toFixed(1)} MB/s`;
        if (bytes >= 1000) return `${(bytes / 1000).toFixed(1)} KB/s`;
        return `${Math.round(bytes)} B/s`;
    }

    onInterfaceNameChanged: {
        previousRx = -1;
        previousTx = -1;
        previousSampleTime = 0;
        refreshDetails();
    }
    onWifiEnabledChanged: {
        if (wifiEnabled) scan();
    }

    Connections {
        target: root.pendingNetwork
        enabled: root.pendingNetwork !== null
        function onConnectionFailed(reason) {
            root.connectionError = `Connection failed: ${ConnectionFailReason.toString(reason)}`;
            root.pendingNetwork = null;
        }
        function onConnectedChanged() {
            if (root.pendingNetwork?.connected) {
                root.connectionError = "";
                root.pendingNetwork = null;
            }
        }
    }

    Component.onCompleted: refreshDetails()

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: root.refreshDetails()
    }

    Timer {
        id: scanStop
        interval: 8000
        onTriggered: {
            if (root.wifiDevice) root.wifiDevice.scannerEnabled = false;
        }
    }

    Process {
        id: addressProcess
        stdout: StdioCollector { onStreamFinished: root.parseAddresses(text) }
    }

    Process {
        id: bandwidthProcess
        stdout: StdioCollector { onStreamFinished: root.parseBandwidth(text) }
    }
}
