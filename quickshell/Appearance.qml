import QtQuick
import qs.Services

QtObject {
    readonly property string textFont: Settings.textFont
    readonly property int fontSize: Settings.fontSize
    readonly property int fontWeight: Settings.fontWeight
    readonly property string iconFont: "JetBrainsMono Nerd Font"

    readonly property color background: Settings.background
    readonly property color surface: Settings.surface
    readonly property color surfaceHover: Settings.surfaceHover
    readonly property color border: Settings.border
    readonly property color text: Settings.text
    readonly property color textMuted: Settings.textMuted
    readonly property color accent: Settings.accent
    readonly property color urgent: Settings.urgent

    readonly property int barHeight: Settings.barHeight
    readonly property int radius: Settings.radius
    readonly property int borderWidth: Settings.borderWidth
    readonly property real barOpacity: Settings.barOpacity / 100
    readonly property int itemRadius: 8
}
