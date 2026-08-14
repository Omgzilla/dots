import QtQuick
import qs.Services

HardwareMetricWidget {
    widgetId: "gpuTemperature"
    widgetLabel: "GPU temperature"
    icon: "󰔏"
    metricValue: PerformanceService.gpuTemperature
    suffix: "°C"
    warningThreshold: 85
}
