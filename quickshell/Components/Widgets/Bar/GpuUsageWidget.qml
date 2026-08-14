import QtQuick
import qs.Services

HardwareMetricWidget {
    widgetId: "gpuUsage"
    widgetLabel: "GPU usage"
    icon: "󰢮"
    metricValue: PerformanceService.gpuUsage
    suffix: "%"
    warningThreshold: 90
}
