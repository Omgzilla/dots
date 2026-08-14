pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property bool active: false
    property string widgetId: ""
    property real globalX: 0
    property real globalY: 0
    property int revision: 0

    signal dropRequested(string widgetId, real globalX, real globalY)

    function begin(widget: string, x: real, y: real): void {
        widgetId = widget;
        active = true;
        update(x, y);
    }

    function update(x: real, y: real): void {
        globalX = x;
        globalY = y;
        revision++;
    }

    function finish(x: real, y: real): void {
        if (!active) return;
        update(x, y);
        dropRequested(widgetId, globalX, globalY);
        cancel();
    }

    function cancel(): void {
        active = false;
        widgetId = "";
        revision++;
    }
}
