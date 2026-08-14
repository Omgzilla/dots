import QtQuick
import qs.Services

HardwareMetricWidget {
    widgetId: "cpuUsage"
    widgetLabel: "CPU usage"
    icon: "󰍛"
    metricValue: PerformanceService.cpuUsage
    suffix: "%"
    warningThreshold: 85
}
