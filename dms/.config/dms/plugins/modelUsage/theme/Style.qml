pragma Singleton
import QtQuick
import "." as DmsTheme
import qs.Common

// Small DMS theme adapter for the upstream view components.
QtObject {
    readonly property real scale: Theme.fontSizeMedium / 14
    readonly property real cornerRadius: Theme.cornerRadiusM
    readonly property var font: ({ family: Theme.fontFamily,
        caption: Theme.fontSizeSmall, bodySmall: Theme.fontSizeMedium,
        body: Theme.fontSizeLarge, title: Theme.fontSizeXLarge,
        display: Theme.fontSizeDisplay })
    readonly property var spacing: ({ xxs: Theme.spacingXXS, xs: Theme.spacingXS,
        sm: Theme.spacingS, md: Theme.spacingS, lg: Theme.spacingM,
        xl: Theme.spacingL, xxl: Theme.spacingL, huge: Theme.spacingXL,
        labelGap: Theme.spacingXS, controlGap: Theme.spacingS,
        controlHeight: Theme.buttonHeightXS, popupRowHeight: Theme.buttonHeightS,
        hairline: Theme.outlineWidth })
    function space(value) { return Math.round(value * scale) }
    function normalFillFor(foreground, accent, urgent) { return DmsTheme.Color.card }
    function hoverFillFor(foreground, accent) { return Theme.withAlpha(Theme.primary, 0.12) }
    function controlFill(focused, hovered, foreground, accent) {
        return focused || hovered ? Theme.surfaceContainerHighest : Theme.surfaceContainerHigh
    }
}
