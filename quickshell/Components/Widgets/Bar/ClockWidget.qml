import QtQuick
import Quickshell
import qs.Components.Menus
import qs.Services

Item {
    id: root
    required property var barScreen
    required property var barWindow
    required property var appearance
    property bool calendarOpen: false
    implicitWidth: label.implicitWidth
    implicitHeight: 26

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: -7
        anchors.rightMargin: -7
        radius: root.appearance.itemRadius
        color: clockMouse.containsMouse || root.calendarOpen ? root.appearance.surfaceHover : "transparent"
    }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Text {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(clock.date, Settings.clockFormat)
              + (Settings.showDate
                 ? Settings.clockDateSeparator + Qt.formatDateTime(clock.date, Settings.dateFormat)
                 : "")
        color: root.appearance.text
        font.family: root.appearance.textFont
        font.pixelSize: root.appearance.fontSize
        font.weight: root.appearance.fontWeight
    }

    MouseArea {
        id: clockMouse
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width
        anchors.leftMargin: -7
        anchors.rightMargin: -7
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Settings.runWidgetCommand("clock");
            else root.calendarOpen = !root.calendarOpen;
        }
    }

    CalendarMenu {
        visible: root.calendarOpen
        barWindow: root.barWindow
        anchorItem: root
        appearance: root.appearance
        onDismissRequested: root.calendarOpen = false
    }
}
