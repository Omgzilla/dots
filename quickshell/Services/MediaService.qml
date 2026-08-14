pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root
    property var activePlayer: null

    function refresh(): void {
        activePlayer = Mpris.players.values.find(player => player.isPlaying) ?? null;
    }

    Component.onCompleted: refresh()

    Connections {
        target: Mpris.players
        function onValuesChanged() { root.refresh(); }
    }

    Instantiator {
        model: Mpris.players
        delegate: Connections {
            required property var modelData
            target: modelData
            function onIsPlayingChanged() { root.refresh(); }
            function onPlaybackStateChanged() { root.refresh(); }
        }
    }
}
