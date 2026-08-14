//@ pragma UseQApplication

import QtQuick
import Quickshell
import qs.Services

ShellRoot {
    Variants {
        model: Settings.ready ? Quickshell.screens : []

        Bar {
            required property var modelData
            screen: modelData
        }
    }
}
