pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var allOutputs: Pipewire.nodes.values.filter(node => node?.audio && node.isSink && !node.isStream)
    readonly property var allInputs: Pipewire.nodes.values.filter(node => node?.audio && !node.isSink && !node.isStream)
    readonly property var outputs: allOutputs.filter(node => !Settings.hiddenAudioOutputs.includes(node.name))
    readonly property var inputs: allInputs.filter(node => !Settings.hiddenAudioInputs.includes(node.name))

    function displayName(node: var): string {
        return node?.description || node?.nickname || node?.name || "Unknown device";
    }

    function setOutput(name: string): void {
        const node = allOutputs.find(item => item.name === name);
        if (node) Pipewire.preferredDefaultAudioSink = node;
    }

    function setInput(name: string): void {
        const node = allInputs.find(item => item.name === name);
        if (node) Pipewire.preferredDefaultAudioSource = node;
    }

    function setVolume(node: var, percent: real): void {
        if (!node?.audio) return;
        node.audio.volume = Math.max(0, Math.min(1.5, percent / 100));
        if (percent > 0) node.audio.muted = false;
    }

    function toggleHidden(name: string, input: bool): void {
        const current = (input ? Settings.hiddenAudioInputs : Settings.hiddenAudioOutputs).slice();
        const next = current.includes(name) ? current.filter(item => item !== name) : [...current, name];
        if (input) Settings.hiddenAudioInputs = next;
        else Settings.hiddenAudioOutputs = next;
    }

    function openPavucontrol(): void {
        Quickshell.execDetached(["pavucontrol"]);
    }

    PwObjectTracker { objects: Pipewire.nodes.values }
}
