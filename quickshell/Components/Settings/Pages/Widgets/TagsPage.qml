import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components.Settings.Controls
import qs.Services

ScrollView {
    id: root
    required property var appearance
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical: SettingsScrollBar { appearance: root.appearance }

    ColumnLayout {
        width: root.availableWidth
        spacing: 10

        ChoiceSetting {
            Layout.fillWidth: true
            label: "Appearance"
            value: Settings.tagStyle
            options: [
                { "label": "Pill", "value": "pill" },
                { "label": "Outline", "value": "outline" },
                { "label": "Minimal", "value": "minimal" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.tagStyle = value
        }
        ChoiceSetting {
            Layout.fillWidth: true
            label: "Tag labels"
            value: Settings.tagLabelMode
            options: [
                { "label": "Numbers", "value": "number" },
                { "label": "Roman numerals", "value": "roman" },
                { "label": "Dots", "value": "dot" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.tagLabelMode = value
        }
        ToggleSetting { Layout.fillWidth: true; label: "Empty tags"; value: Settings.tagShowEmpty; offText: "Hide"; onText: "Show"; appearance: root.appearance; onEdited: value => Settings.tagShowEmpty = value }

        Text { text: "Sizing & spacing"; color: root.appearance.accent; font.family: root.appearance.textFont; font.pixelSize: 12; font.weight: Font.Medium }
        NumberSetting { Layout.fillWidth: true; label: "Active tag width"; value: Settings.tagActiveWidth; from: 16; to: 64; appearance: root.appearance; onEdited: value => Settings.tagActiveWidth = value }
        NumberSetting { Layout.fillWidth: true; label: "Inactive tag width"; value: Settings.tagInactiveWidth; from: 12; to: 56; appearance: root.appearance; onEdited: value => Settings.tagInactiveWidth = value }
        NumberSetting { Layout.fillWidth: true; label: "Tag height"; value: Settings.tagHeight; from: 14; to: 48; appearance: root.appearance; onEdited: value => Settings.tagHeight = value }
        NumberSetting { Layout.fillWidth: true; label: "Spacing"; value: Settings.tagSpacing; from: 0; to: 16; appearance: root.appearance; onEdited: value => Settings.tagSpacing = value }
        NumberSetting { Layout.fillWidth: true; label: "Corner radius"; value: Settings.tagRadius; from: 0; to: 24; appearance: root.appearance; onEdited: value => Settings.tagRadius = value }
        NumberSetting { Layout.fillWidth: true; label: "Inactive opacity (%)"; value: Settings.tagInactiveOpacity; from: 20; to: 100; appearance: root.appearance; onEdited: value => Settings.tagInactiveOpacity = value }

        Text { text: "Indicators"; color: root.appearance.accent; font.family: root.appearance.textFont; font.pixelSize: 12; font.weight: Font.Medium }
        ToggleSetting { Layout.fillWidth: true; label: "Occupied indicators"; value: Settings.tagShowIndicators; offText: "Hide"; onText: "Show"; appearance: root.appearance; onEdited: value => Settings.tagShowIndicators = value }
        ChoiceSetting {
            Layout.fillWidth: true
            label: "Indicator position"
            value: Settings.tagIndicatorPosition
            options: [
                { "label": "Bottom", "value": "bottom" },
                { "label": "Top", "value": "top" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.tagIndicatorPosition = value
        }
        NumberSetting { Layout.fillWidth: true; label: "Active indicator width"; value: Settings.tagActiveIndicatorWidth; from: 2; to: 24; appearance: root.appearance; onEdited: value => Settings.tagActiveIndicatorWidth = value }
        NumberSetting { Layout.fillWidth: true; label: "Occupied indicator width"; value: Settings.tagOccupiedIndicatorWidth; from: 2; to: 16; appearance: root.appearance; onEdited: value => Settings.tagOccupiedIndicatorWidth = value }
        NumberSetting { Layout.fillWidth: true; label: "Indicator thickness"; value: Settings.tagIndicatorHeight; from: 1; to: 6; appearance: root.appearance; onEdited: value => Settings.tagIndicatorHeight = value }
        CommandSetting { Layout.fillWidth: true; label: "Right-click command"; value: Settings.widgetCommand("tags"); appearance: root.appearance; onEdited: value => Settings.setWidgetCommand("tags", value) }
        Item { Layout.fillHeight: true }
    }
}
