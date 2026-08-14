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
        width: parent.availableWidth
        spacing: 10

        readonly property var fontOptions: {
            const families = Qt.fontFamilies().slice().sort((a, b) => a.localeCompare(b));
            return families.map(family => ({ "label": family, "value": family }));
        }

        Text {
            Layout.fillWidth: true
            text: "Changes are previewed immediately. Use Save to keep them."
            wrapMode: Text.WordWrap
            color: root.appearance.textMuted
            font.family: root.appearance.textFont
            font.pixelSize: 11
        }

        Text {
            text: "Bar position"
            color: root.appearance.text
            font.family: root.appearance.textFont
            font.pixelSize: 12
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 7
            Repeater {
                model: ["top", "bottom"]
                delegate: SettingsButton {
                    required property string modelData
                    Layout.fillWidth: true
                    text: modelData === "top" ? "󰁝  Top" : "󰁅  Bottom"
                    selected: Settings.edge === modelData
                    appearance: root.appearance
                    onClicked: Settings.edge = modelData
                }
            }
        }

        ChoiceSetting {
            Layout.fillWidth: true
            label: "Text font"
            description: "Font used for bar labels and settings text."
            value: Settings.textFont
            options: parent.fontOptions
            appearance: root.appearance
            onEdited: value => Settings.textFont = value
        }

        NumberSetting {
            Layout.fillWidth: true
            label: "Font size"
            description: "Base size for text displayed in the bar."
            value: Settings.fontSize
            from: 8
            to: 20
            appearance: root.appearance
            onEdited: value => Settings.fontSize = value
        }

        ChoiceSetting {
            Layout.fillWidth: true
            label: "Font thickness"
            description: "Weight used for primary bar text."
            value: String(Settings.fontWeight)
            options: [
                { "label": "Light", "value": "25" },
                { "label": "Regular", "value": "50" },
                { "label": "Medium", "value": "57" },
                { "label": "Semi-bold", "value": "63" }
            ]
            appearance: root.appearance
            onEdited: value => Settings.fontWeight = Number(value)
        }

        NumberSetting {
            Layout.fillWidth: true
            label: "Bar height"
            description: "Total height of the bar in pixels."
            value: Settings.barHeight
            from: 16
            to: 64
            appearance: root.appearance
            onEdited: value => Settings.barHeight = value
        }

        SectionTitle { text: "Border & transparency"; appearance: root.appearance }
        NumberSetting {
            Layout.fillWidth: true
            label: "Border width"
            description: "Outline around the bar."
            value: Settings.borderWidth
            from: 0
            to: 4
            appearance: root.appearance
            onEdited: value => Settings.borderWidth = value
        }
        NumberSetting {
            Layout.fillWidth: true
            label: "Background opacity (%)"
            description: "Transparency of the bar background."
            value: Settings.barOpacity
            from: 0
            to: 100
            appearance: root.appearance
            onEdited: value => Settings.barOpacity = value
        }
        Item { Layout.fillHeight: true }
    }
}
