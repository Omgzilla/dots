import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components.Settings.Controls
import qs.Services

Item {
    id: root
    required property var appearance
    property string targetSection: "audio"
    property string selectedOutputName: ""
    property string referenceOutputName: ""
    property string arrangementMode: "extend"
    property string extendDirection: "right"
    readonly property var selectedOutput: DisplayService.output(selectedOutputName)
    readonly property var referenceOutputs: DisplayService.outputs.filter(output => output.name !== selectedOutputName)

    function ensureOutput(): void {
        if (!DisplayService.output(selectedOutputName))
            selectedOutputName = DisplayService.outputs[0]?.name ?? "";
        if (!referenceOutputs.some(output => output.name === referenceOutputName))
            referenceOutputName = referenceOutputs[0]?.name ?? "";
    }

    onTargetSectionChanged: {
        if (targetSection !== "audio" && targetSection !== "display")
            targetSection = "audio";
    }

    Connections {
        target: DisplayService
        function onOutputsChanged() { root.ensureOutput(); }
    }
    Component.onCompleted: {
        if (targetSection !== "audio" && targetSection !== "display")
            targetSection = "audio";
        ensureOutput();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ScrollView {
            id: systemScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical: SettingsScrollBar { appearance: root.appearance }

            ColumnLayout {
                width: systemScroll.availableWidth
                spacing: 10

                Text {
                    visible: root.targetSection === "audio"
                    Layout.fillWidth: true
                    text: "Default devices and levels apply to the whole PipeWire session. Widget appearance remains under Widget settings → Audio."
                    wrapMode: Text.WordWrap
                    color: root.appearance.textMuted
                    font.family: root.appearance.textFont
                    font.pixelSize: 11
                }
                ChoiceSetting {
                    visible: root.targetSection === "audio"
                    Layout.fillWidth: true
                    label: "Default output"
                    value: AudioService.sink?.name ?? ""
                    options: AudioService.outputs.map(node => ({ "label": AudioService.displayName(node), "value": node.name }))
                    appearance: root.appearance
                    onEdited: value => AudioService.setOutput(value)
                }
                NumberSetting {
                    visible: root.targetSection === "audio"
                    Layout.fillWidth: true
                    label: "Output volume"
                    value: Math.round((AudioService.sink?.audio?.volume ?? 0) * 100)
                    from: 0
                    to: 150
                    appearance: root.appearance
                    onEdited: value => AudioService.setVolume(AudioService.sink, value)
                }
                ChoiceSetting {
                    visible: root.targetSection === "audio"
                    Layout.fillWidth: true
                    label: "Default input"
                    value: AudioService.source?.name ?? ""
                    options: AudioService.inputs.map(node => ({ "label": AudioService.displayName(node), "value": node.name }))
                    appearance: root.appearance
                    onEdited: value => AudioService.setInput(value)
                }
                NumberSetting {
                    visible: root.targetSection === "audio"
                    Layout.fillWidth: true
                    label: "Input volume"
                    value: Math.round((AudioService.source?.audio?.volume ?? 0) * 100)
                    from: 0
                    to: 150
                    appearance: root.appearance
                    onEdited: value => AudioService.setVolume(AudioService.source, value)
                }
                Text {
                    visible: root.targetSection === "audio"
                    text: "Output devices"
                    color: root.appearance.text
                    font.family: root.appearance.textFont
                    font.pixelSize: 12
                }
                Repeater {
                    model: root.targetSection === "audio" ? AudioService.allOutputs : []
                    delegate: RowLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        Text { Layout.fillWidth: true; text: AudioService.displayName(parent.modelData); color: root.appearance.textMuted; elide: Text.ElideRight; font.family: root.appearance.textFont; font.pixelSize: 10 }
                        SettingsButton { compact: true; implicitWidth: 54; enabled: parent.modelData !== AudioService.sink; text: Settings.hiddenAudioOutputs.includes(parent.modelData.name) ? "Show" : "Hide"; appearance: root.appearance; onClicked: AudioService.toggleHidden(parent.modelData.name, false) }
                    }
                }
                Text {
                    visible: root.targetSection === "audio"
                    text: "Input devices"
                    color: root.appearance.text
                    font.family: root.appearance.textFont
                    font.pixelSize: 12
                }
                Repeater {
                    model: root.targetSection === "audio" ? AudioService.allInputs : []
                    delegate: RowLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        Text { Layout.fillWidth: true; text: AudioService.displayName(parent.modelData); color: root.appearance.textMuted; elide: Text.ElideRight; font.family: root.appearance.textFont; font.pixelSize: 10 }
                        SettingsButton { compact: true; implicitWidth: 54; enabled: parent.modelData !== AudioService.source; text: Settings.hiddenAudioInputs.includes(parent.modelData.name) ? "Show" : "Hide"; appearance: root.appearance; onClicked: AudioService.toggleHidden(parent.modelData.name, true) }
                    }
                }
                SettingsButton {
                    visible: root.targetSection === "audio"
                    Layout.fillWidth: true
                    text: "󰒓  Open Pavucontrol"
                    appearance: root.appearance
                    onClicked: AudioService.openPavucontrol()
                }

                Text {
                    visible: root.targetSection === "display"
                    Layout.fillWidth: true
                    text: "Each connected output has independent mode, scale, rotation, and arrangement controls. Changes apply immediately for this Mango session."
                    wrapMode: Text.WordWrap
                    color: root.appearance.textMuted
                    font.family: root.appearance.textFont
                    font.pixelSize: 11
                }
                ChoiceSetting {
                    visible: root.targetSection === "display" && DisplayService.outputs.length > 0
                    Layout.fillWidth: true
                    label: "Display"
                    value: root.selectedOutputName
                    options: DisplayService.outputs.map((output, index) => ({
                        "label": `Display ${index + 1} — ${output.name} (${output.width} × ${output.height})`,
                        "value": output.name
                    }))
                    appearance: root.appearance
                    onEdited: value => {
                        root.selectedOutputName = value;
                        root.ensureOutput();
                    }
                }
                ChoiceSetting {
                    visible: root.targetSection === "display" && root.selectedOutput !== null
                    Layout.fillWidth: true
                    label: "Resolution and refresh rate"
                    value: DisplayService.modeValue(root.selectedOutput)
                    options: DisplayService.modeOptions(root.selectedOutput)
                    appearance: root.appearance
                    onEdited: value => DisplayService.apply(root.selectedOutputName, value, String(root.selectedOutput.scale), String(root.selectedOutput.transform))
                }
                ChoiceSetting {
                    visible: root.targetSection === "display" && root.selectedOutput !== null
                    Layout.fillWidth: true
                    label: "Scale"
                    value: String(root.selectedOutput?.scale ?? 1)
                    options: DisplayService.scaleOptionsFor(root.selectedOutput)
                    appearance: root.appearance
                    onEdited: value => DisplayService.apply(root.selectedOutputName, DisplayService.modeValue(root.selectedOutput), value, String(root.selectedOutput.transform))
                }
                ChoiceSetting {
                    visible: root.targetSection === "display" && root.selectedOutput !== null
                    Layout.fillWidth: true
                    label: "Rotation"
                    value: String(root.selectedOutput?.transform ?? 0)
                    options: DisplayService.transformOptions
                    appearance: root.appearance
                    onEdited: value => DisplayService.apply(root.selectedOutputName, DisplayService.modeValue(root.selectedOutput), String(root.selectedOutput.scale), value)
                }
                SectionTitle {
                    visible: root.targetSection === "display" && DisplayService.outputs.length > 1
                    text: "Multi-monitor arrangement"
                    separator: true
                    appearance: root.appearance
                }
                ChoiceSetting {
                    visible: root.targetSection === "display" && DisplayService.outputs.length > 1
                    Layout.fillWidth: true
                    label: "Use selected display as"
                    value: root.arrangementMode
                    options: [
                        { "label": "Extended desktop", "value": "extend" },
                        { "label": "Mirror another display (experimental)", "value": "mirror" }
                    ]
                    appearance: root.appearance
                    onEdited: value => {
                        root.arrangementMode = value;
                        DisplayService.arrange(root.selectedOutputName, root.referenceOutputName, value, root.extendDirection);
                    }
                }
                ChoiceSetting {
                    visible: root.targetSection === "display" && DisplayService.outputs.length > 1
                    Layout.fillWidth: true
                    label: root.arrangementMode === "mirror" ? "Mirror display" : "Position relative to"
                    value: root.referenceOutputName
                    options: root.referenceOutputs.map((output, index) => ({
                        "label": `${output.name} (${output.width} × ${output.height})`,
                        "value": output.name
                    }))
                    appearance: root.appearance
                    onEdited: value => {
                        root.referenceOutputName = value;
                        DisplayService.arrange(root.selectedOutputName, value, root.arrangementMode, root.extendDirection);
                    }
                }
                ChoiceSetting {
                    visible: root.targetSection === "display" && DisplayService.outputs.length > 1 && root.arrangementMode === "extend"
                    Layout.fillWidth: true
                    label: "Extended position"
                    value: root.extendDirection
                    options: [
                        { "label": "Right", "value": "right" },
                        { "label": "Left", "value": "left" },
                        { "label": "Above", "value": "above" },
                        { "label": "Below", "value": "below" }
                    ]
                    appearance: root.appearance
                    onEdited: value => {
                        root.extendDirection = value;
                        DisplayService.arrange(root.selectedOutputName, root.referenceOutputName, "extend", value);
                    }
                }
                Text {
                    visible: root.targetSection === "display" && DisplayService.outputs.length > 1 && root.arrangementMode === "mirror"
                    Layout.fillWidth: true
                    text: "Mango does not expose a dedicated clone option. Experimental mirroring aligns both outputs to the same logical coordinates and matches the selected output to the reference mode."
                    wrapMode: Text.WordWrap
                    color: root.appearance.textMuted
                    font.family: root.appearance.textFont
                    font.pixelSize: 10
                }
                Text {
                    visible: root.targetSection === "display" && DisplayService.error.length > 0
                    Layout.fillWidth: true
                    text: DisplayService.error
                    wrapMode: Text.WordWrap
                    color: root.appearance.urgent
                    font.family: root.appearance.textFont
                    font.pixelSize: 11
                }
                Text {
                    visible: root.targetSection === "display" && DisplayService.lastResult.length > 0
                    Layout.fillWidth: true
                    text: DisplayService.lastResult
                    wrapMode: Text.WordWrap
                    color: root.appearance.accent
                    font.family: root.appearance.textFont
                    font.pixelSize: 11
                }
                SettingsButton {
                    visible: root.targetSection === "display"
                    Layout.fillWidth: true
                    text: DisplayService.loading ? "Refreshing…" : "󰑓  Refresh displays"
                    enabled: !DisplayService.loading
                    appearance: root.appearance
                    onClicked: DisplayService.refresh()
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
