pragma Singleton
import QtQuick
import "." as DmsTheme

QtObject {
    function flat(color, width) { return { color: color, width: width } }
    function controlSpec(state, foreground, accent, urgent) {
        return { color: state === "focus" ? DmsTheme.Color.accent : DmsTheme.Color.outline, width: 1 }
    }
}
