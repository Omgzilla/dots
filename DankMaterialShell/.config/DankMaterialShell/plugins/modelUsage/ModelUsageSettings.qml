import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root

    pluginId: "modelUsage"

    property int providerRevision: 0

    function enabledProviders() {
        const value = root.loadValue("enabledProviders", ["claude", "codex", "kimi"]);
        return Array.isArray(value) ? value : ["claude", "codex", "kimi"];
    }

    function providerEnabled(providerId) {
        // Keep a QML dependency so custom provider toggles update after saving.
        const revision = root.providerRevision;
        return root.enabledProviders().indexOf(providerId) !== -1;
    }

    function setProviderEnabled(providerId, enabled) {
        let providers = root.enabledProviders().filter(id => id !== providerId);
        if (enabled)
            providers.push(providerId);
        root.saveValue("enabledProviders", providers);
        root.providerRevision++;
    }

    Column {
        width: parent.width
        spacing: Theme.spacingM

        StyledText {
            width: parent.width
            text: "Model Usage"
            color: Theme.surfaceText
            font.pixelSize: Theme.fontSizeLarge
            font.weight: Font.Medium
        }

        StyledText {
            width: parent.width
            text: "Read-only usage checks for Claude Code, OpenAI Codex, and Kimi Code. Sign in with each provider's own CLI before enabling it."
            color: Theme.surfaceTextMedium
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
        }

        Column {
            width: parent.width
            spacing: Theme.spacingS

            StyledText {
                text: "Providers"
                color: Theme.surfaceText
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
            }

            Repeater {
                model: [
                    {
                        id: "claude",
                        label: "Claude Code",
                        description: "Claude subscription usage and extra usage"
                    },
                    {
                        id: "codex",
                        label: "OpenAI Codex",
                        description: "Codex rate limits and credit balance"
                    },
                    {
                        id: "kimi",
                        label: "Kimi Code",
                        description: "Kimi Code usage windows"
                    }
                ]

                delegate: Item {
                    required property var modelData
                    width: parent.width
                    implicitHeight: providerInfo.implicitHeight

                    Column {
                        id: providerInfo
                        width: parent.width - providerToggle.width - Theme.spacingM
                        spacing: Theme.spacingXS
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        StyledText {
                            width: parent.width
                            text: modelData.label
                            color: Theme.surfaceText
                            font.pixelSize: Theme.fontSizeMedium
                            font.weight: Font.Medium
                        }

                        StyledText {
                            width: parent.width
                            text: modelData.description
                            color: Theme.surfaceTextMedium
                            font.pixelSize: Theme.fontSizeSmall
                            wrapMode: Text.WordWrap
                        }
                    }

                    DankToggle {
                        id: providerToggle
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        checked: root.providerEnabled(modelData.id)
                        onToggled: isChecked => root.setProviderEnabled(modelData.id, isChecked)
                    }
                }
            }
        }

        SelectionSetting {
            settingKey: "refreshIntervalSec"
            label: "Refresh interval"
            description: "How often the provider usage is refreshed. Manual refresh is always available."
            options: [
                { label: "1 minute", value: "60" },
                { label: "5 minutes", value: "300" },
                { label: "15 minutes", value: "900" },
                { label: "30 minutes", value: "1800" },
                { label: "1 hour", value: "3600" }
            ]
            defaultValue: "900"
        }

        SelectionSetting {
            settingKey: "barDisplayMode"
            label: "Bar display"
            description: "Percentages shows one compact remaining-quota chip per provider on horizontal bars."
            options: ["Icon", "Percentages"]
            defaultValue: "Icon"
        }

        SliderSetting {
            settingKey: "warningThreshold"
            label: "Warning threshold"
            description: "Mark a provider urgent at or below this percentage remaining."
            defaultValue: 25
            minimum: 1
            maximum: 100
            unit: "%"
        }

        SliderSetting {
            settingKey: "criticalThreshold"
            label: "Critical threshold"
            description: "Use the critical color at or below this percentage remaining."
            defaultValue: 10
            minimum: 0
            maximum: 100
            unit: "%"
        }

        StyledText {
            width: parent.width
            text: "Provider commands: claude auth login, codex login, kimi login. State is stored under $XDG_STATE_HOME/DankMaterialShell/model-usage (or ~/.local/state/DankMaterialShell/model-usage)."
            color: Theme.surfaceTextMedium
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
        }
    }
}
