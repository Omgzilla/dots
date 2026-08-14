import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components.Settings.Controls
import qs.Services

ScrollView {
    id: root
    required property var appearance
    readonly property var palettes: ({
        "default": {
            "background": "#e611151c", "surface": "#ff1a2029", "surfaceHover": "#ff242c38", "border": "#ff303947",
            "text": "#ffe6edf3", "textMuted": "#ff8b98a8", "accent": "#ff8ab4f8", "urgent": "#ffff7b72"
        },
        "catppuccin": {
            "background": "#ff1e1e2e", "surface": "#ff313244", "surfaceHover": "#ff45475a", "border": "#ff585b70",
            "text": "#ffcdd6f4", "textMuted": "#ffa6adc8", "accent": "#ffcba6f7", "urgent": "#fff38ba8"
        },
        "dracula": {
            "background": "#ff282a36", "surface": "#ff343746", "surfaceHover": "#ff44475a", "border": "#ff6272a4",
            "text": "#fff8f8f2", "textMuted": "#ffbfbfbf", "accent": "#ffbd93f9", "urgent": "#ffff5555"
        },
        "gruvbox": {
            "background": "#ff282828", "surface": "#ff3c3836", "surfaceHover": "#ff504945", "border": "#ff665c54",
            "text": "#ffebdbb2", "textMuted": "#ffa89984", "accent": "#ffd79921", "urgent": "#fffb4934"
        },
        "tokyoNight": {
            "background": "#ff1a1b26", "surface": "#ff24283b", "surfaceHover": "#ff414868", "border": "#ff565f89",
            "text": "#ffc0caf5", "textMuted": "#ff9aa5ce", "accent": "#ff7aa2f7", "urgent": "#fff7768e"
        },
        "nord": {
            "background": "#ff2e3440", "surface": "#ff3b4252", "surfaceHover": "#ff434c5e", "border": "#ff4c566a",
            "text": "#ffeceff4", "textMuted": "#ffd8dee9", "accent": "#ff88c0d0", "urgent": "#ffbf616a"
        }
    })

    function applyPalette(name: string): void {
        if (name === "custom") {
            Settings.colorPalette = "custom";
            return;
        }
        const palette = palettes[name];
        if (!palette) return;
        Settings.background = palette.background;
        Settings.surface = palette.surface;
        Settings.surfaceHover = palette.surfaceHover;
        Settings.border = palette.border;
        Settings.text = palette.text;
        Settings.textMuted = palette.textMuted;
        Settings.accent = palette.accent;
        Settings.urgent = palette.urgent;
        Settings.colorPalette = name;
    }

    function editColor(propertyName: string, value: string): void {
        Settings[propertyName] = value;
        Settings.colorPalette = "custom";
    }
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical: SettingsScrollBar { appearance: root.appearance }

    ColumnLayout {
        width: parent.availableWidth
        spacing: 8
        ChoiceSetting {
            Layout.fillWidth: true
            label: "Palette"
            description: "Start from a coordinated color scheme."
            value: Settings.colorPalette
            options: [
                { "label": "Default", "value": "default" },
                { "label": "Catppuccin Mocha", "value": "catppuccin" },
                { "label": "Dracula", "value": "dracula" },
                { "label": "Gruvbox Dark", "value": "gruvbox" },
                { "label": "Tokyo Night", "value": "tokyoNight" },
                { "label": "Nord", "value": "nord" },
                { "label": "Custom", "value": "custom" }
            ]
            appearance: root.appearance
            onEdited: value => root.applyPalette(value)
        }
        Text {
            Layout.fillWidth: true
            text: "Changing an individual color keeps the rest of the palette and switches the selection to Custom."
            wrapMode: Text.WordWrap
            color: root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: 11
        }
        ColorSetting { Layout.fillWidth: true; label: "Background"; value: Settings.background; appearance: root.appearance; onEdited: value => root.editColor("background", value) }
        ColorSetting { Layout.fillWidth: true; label: "Surface"; value: Settings.surface; appearance: root.appearance; onEdited: value => root.editColor("surface", value) }
        ColorSetting { Layout.fillWidth: true; label: "Hover"; value: Settings.surfaceHover; appearance: root.appearance; onEdited: value => root.editColor("surfaceHover", value) }
        ColorSetting { Layout.fillWidth: true; label: "Border"; value: Settings.border; appearance: root.appearance; onEdited: value => root.editColor("border", value) }
        ColorSetting { Layout.fillWidth: true; label: "Text"; value: Settings.text; appearance: root.appearance; onEdited: value => root.editColor("text", value) }
        ColorSetting { Layout.fillWidth: true; label: "Muted text"; value: Settings.textMuted; appearance: root.appearance; onEdited: value => root.editColor("textMuted", value) }
        ColorSetting { Layout.fillWidth: true; label: "Accent"; value: Settings.accent; appearance: root.appearance; onEdited: value => root.editColor("accent", value) }
        ColorSetting { Layout.fillWidth: true; label: "Urgent"; value: Settings.urgent; appearance: root.appearance; onEdited: value => root.editColor("urgent", value) }
    }
}
