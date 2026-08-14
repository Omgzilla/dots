import QtQuick

Item {
    id: root
    required property var popup
    property bool hadFocus: false
    property var popupWindow: null
    signal dismissRequested
    width: 0
    height: 0

    Connections {
        target: root.popup
        function onWindowConnected() {
            root.popupWindow = root.popup._backingWindow;
        }
        function onVisibleChanged() {
            if (!root.popup.visible) {
                root.hadFocus = false;
            } else {
                Qt.callLater(() => {
                    if (!root.popupWindow)
                        root.popupWindow = root.popup._backingWindow;
                    if (root.popupWindow?.active)
                        root.hadFocus = true;
                });
            }
        }
    }

    Connections {
        target: root.popupWindow
        function onActiveChanged() {
            if (target.active) {
                root.hadFocus = true;
            } else if (root.hadFocus && root.popup.visible) {
                Qt.callLater(root.dismissRequested);
            }
        }
    }

    Shortcut {
        sequences: [StandardKey.Cancel]
        context: Qt.WindowShortcut
        onActivated: {
            if (root.popup.visible)
                root.dismissRequested();
        }
    }
}
