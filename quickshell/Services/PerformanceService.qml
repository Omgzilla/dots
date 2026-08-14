pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpuUsage: -1
    property int cpuTemperature: -1
    property int gpuUsage: -1
    property int gpuTemperature: -1
    property double previousCpuTotal: -1
    property double previousCpuIdle: -1

    readonly property bool cpuUsageAvailable: cpuUsage >= 0
    readonly property bool cpuTemperatureAvailable: cpuTemperature >= 0
    readonly property bool gpuUsageAvailable: gpuUsage >= 0
    readonly property bool gpuTemperatureAvailable: gpuTemperature >= 0

    function refresh(): void {
        if (!cpuProcess.running)
            cpuProcess.running = true;
        if (!sensorProcess.running)
            sensorProcess.running = true;
    }

    function parseCpu(text: string): void {
        const line = text.split("\n")[0]?.trim() ?? "";
        const fields = line.split(/\s+/);
        if (fields[0] !== "cpu" || fields.length < 6) return;

        const values = fields.slice(1).map(value => Number(value));
        if (values.some(value => !Number.isFinite(value))) return;
        const idle = values[3] + (values[4] ?? 0);
        const total = values.reduce((sum, value) => sum + value, 0);

        if (previousCpuTotal >= 0 && total > previousCpuTotal) {
            const totalDelta = total - previousCpuTotal;
            const idleDelta = idle - previousCpuIdle;
            cpuUsage = Math.max(0, Math.min(100,
                Math.round((1 - idleDelta / totalDelta) * 100)));
        }
        previousCpuTotal = total;
        previousCpuIdle = idle;
    }

    function parseSensors(text: string): void {
        const values = text.trim().split("|").map(value => Number(value.trim()));
        if (values.length !== 3) return;
        cpuTemperature = Number.isFinite(values[0]) ? values[0] : -1;
        gpuUsage = Number.isFinite(values[1]) ? values[1] : -1;
        gpuTemperature = Number.isFinite(values[2]) ? values[2] : -1;
    }

    Component.onCompleted: refresh()

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: root.refresh()
    }

    Process {
        id: cpuProcess
        command: ["cat", "/proc/stat"]
        stdout: StdioCollector { onStreamFinished: root.parseCpu(text) }
    }

    Process {
        id: sensorProcess
        command: ["bash", Quickshell.shellPath("Scripts/hardware-metrics.sh")]
        stdout: StdioCollector { onStreamFinished: root.parseSensors(text) }
    }
}
