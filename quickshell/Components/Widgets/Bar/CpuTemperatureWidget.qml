import QtQuick
import qs.Services

HardwareMetricWidget {
    widgetId: "cpuTemperature"
    widgetLabel: "CPU temperature"
    icon: "󰔏"
    metricValue: PerformanceService.cpuTemperature
    suffix: "°C"
    warningThreshold: 85
}
