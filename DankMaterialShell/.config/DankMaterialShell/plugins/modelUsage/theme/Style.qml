pragma Singleton
import QtQuick
import "." as DmsTheme
import qs.Common

// Small DMS theme adapter for the upstream view components.
QtObject {
    readonly property real scale: Theme.fontSizeMedium / 14
    readonly property real cornerRadius: Theme.cornerRadius
    readonly property var font: ({ family: Theme.fontFamily,
        caption: Theme.fontSizeSmall, bodySmall: Theme.fontSizeMedium,
        body: Theme.fontSizeLarge, title: Theme.fontSizeLarge + 2,
        display: Theme.fontSizeLarge * 2.1 })
    readonly property var spacing: ({ xxs: space(2), xs: space(4), sm: space(6),
        md: space(8), lg: space(12), xl: space(14), xxl: space(16), huge: space(24),
        labelGap: space(4), controlGap: space(8), controlHeight: space(30),
        popupRowHeight: space(36), hairline: 1 })
    function space(value) { return Math.round(value * scale) }
    function normalFillFor(foreground, accent, urgent) { return DmsTheme.Color.card }
    function hoverFillFor(foreground, accent) { return Theme.withAlpha(Theme.primary, 0.12) }
    function controlFill(focused, hovered, foreground, accent) {
        return focused || hovered ? Theme.surfaceContainerHighest : Theme.surfaceContainerHigh
    }
}
