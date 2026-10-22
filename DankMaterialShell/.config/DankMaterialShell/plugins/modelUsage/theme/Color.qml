pragma Singleton
import QtQuick
import qs.Common

QtObject {
    readonly property color foreground: Theme.surfaceText
    readonly property color dim: Theme.surfaceTextMedium
    readonly property color accent: Theme.primary
    readonly property color onAccent: Theme.primaryText
    readonly property color secondary: Theme.secondary
    readonly property color tertiary: Theme.tertiary
    readonly property color urgent: Theme.error
    readonly property color outline: Theme.outline
    readonly property color card: Theme.surfaceContainerHigh
    readonly property var popups: ({ background: Theme.surfaceContainer })
}
