pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var outputs: []
    property bool loading: false
    property string error: ""
    property string lastResult: ""
    property var transformOverrides: ({})

    readonly property var scaleOptions: [
        { "label": "100%", "value": "1" },
        { "label": "125%", "value": "1.25" },
        { "label": "150%", "value": "1.5" },
        { "label": "175%", "value": "1.75" },
        { "label": "200%", "value": "2" }
    ]
    readonly property var transformOptions: [
        { "label": "Normal", "value": "0" },
        { "label": "90° counter-clockwise", "value": "1" },
        { "label": "180°", "value": "2" },
        { "label": "270° counter-clockwise", "value": "3" },
        { "label": "Flipped", "value": "4" },
        { "label": "Flipped + 90°", "value": "5" },
        { "label": "Flipped + 180°", "value": "6" },
        { "label": "Flipped + 270°", "value": "7" }
    ]

    function refresh(): void {
        if (query.running) return;
        loading = true;
        error = "";
        query.running = true;
    }

    function output(name: string): var {
        return outputs.find(item => item.name === name) ?? null;
    }

    function modeValue(output: var): string {
        if (!output) return "";
        return `${output.width}x${output.height}@${Number(output.refresh).toFixed(3)}`;
    }

    function modeLabel(mode: var): string {
        const rate = Number(mode.refresh);
        return `${mode.width} × ${mode.height} @ ${rate.toFixed(rate % 1 === 0 ? 0 : 3)} Hz`;
    }

    function modeOptions(output: var): var {
        return (output?.modes ?? []).map(mode => ({
            "label": modeLabel(mode),
            "value": `${mode.width}x${mode.height}@${Number(mode.refresh).toFixed(3)}`
        }));
    }

    function scaleOptionsFor(output: var): var {
        const current = String(output?.scale ?? 1);
        const options = scaleOptions.slice();
        if (!options.some(option => option.value === current))
            options.push({ "label": `${Math.round(Number(current) * 100)}%`, "value": current });
        return options.sort((a, b) => Number(a.value) - Number(b.value));
    }

    function parse(text: string): void {
        const next = [];
        const byName = {};
        for (const line of text.trim().split("\n")) {
            const fields = line.split("\t");
            if (fields[0] === "OUTPUT" && fields.length >= 9) {
                const output = {
                    "name": fields[1],
                    "width": Number(fields[2]),
                    "height": Number(fields[3]),
                    "refresh": Number(fields[4]),
                    "scale": Number(fields[5]),
                    "x": Number(fields[6]),
                    "y": Number(fields[7]),
                    "active": fields[8] === "true",
                    "transform": root.transformOverrides[fields[1]] ?? 0,
                    "modes": []
                };
                next.push(output);
                byName[output.name] = output;
            } else if (fields[0] === "MODE" && fields.length >= 5 && byName[fields[1]]) {
                const output = byName[fields[1]];
                const mode = { "width": Number(fields[2]), "height": Number(fields[3]), "refresh": Number(fields[4]) };
                const key = `${mode.width}x${mode.height}@${mode.refresh.toFixed(3)}`;
                if (!output.modes.some(item => `${item.width}x${item.height}@${item.refresh.toFixed(3)}` === key))
                    output.modes.push(mode);
            }
        }
        for (const output of next)
            output.modes.sort((a, b) => b.width - a.width || b.height - a.height || b.refresh - a.refresh);
        outputs = next;
        error = next.length ? "" : "No Mango outputs were returned.";
    }

    function apply(name: string, modeValue: string, scaleValue: string, transformValue: string): void {
        const output = root.output(name);
        if (!output) return;
        applyAt(name, modeValue, scaleValue, transformValue, output.x, output.y, true);
    }

    function applyAt(name: string, modeValue: string, scaleValue: string, transformValue: string,
                     x: int, y: int, scheduleRefresh: bool): void {
        const output = root.output(name);
        const match = /^(\d+)x(\d+)@([0-9.]+)$/.exec(modeValue);
        if (!output || !match) return;
        const width = Number(match[1]);
        const height = Number(match[2]);
        const refreshRate = Number(match[3]);
        const scale = Number(scaleValue);
        const transform = Number(transformValue);
        const overrides = Object.assign({}, transformOverrides);
        overrides[name] = transform;
        transformOverrides = overrides;
        const rule = `setoption,monitorrule,name:^${name}$,width:${width},height:${height},refresh:${refreshRate},x:${Math.max(0, x)},y:${Math.max(0, y)},scale:${scale},rr:${transform}`;
        Quickshell.execDetached(["mmsg", "dispatch", rule]);
        lastResult = `Applied ${width} × ${height} @ ${refreshRate} Hz to ${name}`;
        if (scheduleRefresh) refreshDelay.restart();
    }

    function arrange(name: string, referenceName: string, arrangement: string, direction: string): void {
        const output = root.output(name);
        const reference = root.output(referenceName);
        if (!output || !reference || output.name === reference.name) return;

        if (arrangement === "mirror") {
            // Mango has no documented clone primitive. Overlapping logical
            // output coordinates is the closest wlroots-compatible behavior.
            applyAt(output.name, modeValue(reference), String(reference.scale), String(output.transform),
                    reference.x, reference.y, true);
            lastResult = `Experimental mirror: ${output.name} overlaps ${reference.name}`;
            return;
        }

        const referenceWidth = Math.round(reference.width / Math.max(0.01, reference.scale));
        const referenceHeight = Math.round(reference.height / Math.max(0.01, reference.scale));
        const outputWidth = Math.round(output.width / Math.max(0.01, output.scale));
        const outputHeight = Math.round(output.height / Math.max(0.01, output.scale));
        let x = reference.x;
        let y = reference.y;
        if (direction === "right") x = reference.x + referenceWidth;
        else if (direction === "left") x = reference.x - outputWidth;
        else if (direction === "below") y = reference.y + referenceHeight;
        else if (direction === "above") y = reference.y - outputHeight;

        const shiftX = Math.max(0, -x);
        const shiftY = Math.max(0, -y);
        if (shiftX > 0 || shiftY > 0) {
            for (const item of outputs) {
                if (item.name === output.name) continue;
                applyAt(item.name, modeValue(item), String(item.scale), String(item.transform),
                        item.x + shiftX, item.y + shiftY, false);
            }
            x += shiftX;
            y += shiftY;
        }
        applyAt(output.name, modeValue(output), String(output.scale), String(output.transform), x, y, true);
        lastResult = `Extended ${output.name} ${direction} of ${reference.name}`;
    }

    Process {
        id: query
        command: ["bash", Quickshell.shellPath("Scripts/display-info.sh")]
        stdout: StdioCollector { onStreamFinished: root.parse(text) }
        onExited: exitCode => {
            root.loading = false;
            if (exitCode !== 0) root.error = "Display information is unavailable. MangoWM, jq and edid-decode are required.";
        }
    }

    Timer { id: refreshDelay; interval: 900; onTriggered: root.refresh() }
    Component.onCompleted: refresh()
}
