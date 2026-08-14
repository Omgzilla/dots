import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Components.Common
import qs.Services

PopupWindow {
    id: root
    required property var barWindow
    required property var anchorItem
    required property var appearance
    signal dismissRequested
    grabFocus: true
    property date shownMonth: new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)

    function shiftMonth(offset: int): void {
        shownMonth = new Date(shownMonth.getFullYear(), shownMonth.getMonth() + offset, 1);
    }

    function startOffset(): int {
        const weekday = new Date(shownMonth.getFullYear(), shownMonth.getMonth(), 1).getDay();
        return Settings.calendarFirstDay === "monday" ? (weekday + 6) % 7 : weekday;
    }

    function cellDate(dayIndex: int): date {
        return new Date(shownMonth.getFullYear(), shownMonth.getMonth(), dayIndex - startOffset() + 1);
    }

    function isoWeek(value: date): int {
        const date = new Date(Date.UTC(value.getFullYear(), value.getMonth(), value.getDate()));
        date.setUTCDate(date.getUTCDate() + 4 - (date.getUTCDay() || 7));
        const yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
        return Math.ceil((((date - yearStart) / 86400000) + 1) / 7);
    }

    function isToday(value: date): bool {
        return value.getFullYear() === clock.date.getFullYear()
            && value.getMonth() === clock.date.getMonth()
            && value.getDate() === clock.date.getDate();
    }

    anchor.window: barWindow
    anchor.rect.x: Settings.popupX("clock", barWindow.width, implicitWidth)
    anchor.rect.y: Settings.edge === "top"
                   ? barWindow.height + 7
                   : -implicitHeight - 7
    implicitWidth: 350
    implicitHeight: 336
    color: "transparent"

    PopupFocusCloser { popup: root; onDismissRequested: root.dismissRequested() }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Rectangle {
        anchors.fill: parent
        radius: root.appearance.radius + 2
        color: root.appearance.background
        border.width: 1
        border.color: root.appearance.border

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                CalendarButton { text: "󰅁"; appearance: root.appearance; onClicked: root.shiftMonth(-1) }
                Text {
                    Layout.fillWidth: true
                    text: Qt.formatDate(root.shownMonth, "MMMM yyyy")
                    color: root.appearance.text
                    horizontalAlignment: Text.AlignHCenter
                    font.family: root.appearance.textFont
                    font.pixelSize: 15
                    font.weight: Font.Medium
                }
                CalendarButton { text: "󰅂"; appearance: root.appearance; onClicked: root.shiftMonth(1) }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: Settings.calendarShowWeekNumbers ? 8 : 7
                rowSpacing: 3
                columnSpacing: 3

                Repeater {
                    model: Settings.calendarShowWeekNumbers ? 8 : 7
                    delegate: Text {
                        required property int index
                        Layout.fillWidth: true
                        Layout.preferredHeight: 22
                        readonly property int dayIndex: Settings.calendarShowWeekNumbers ? index - 1 : index
                        text: Settings.calendarShowWeekNumbers && index === 0
                              ? "W" : (Settings.calendarFirstDay === "monday"
                                       ? ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"][dayIndex]
                                       : ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"][dayIndex])
                        color: root.appearance.textMuted
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: root.appearance.textFont
                        font.pixelSize: 10
                        font.weight: Font.Medium
                    }
                }

                Repeater {
                    model: Settings.calendarShowWeekNumbers ? 48 : 42
                    delegate: Rectangle {
                        id: cell
                        required property int index
                        readonly property int columnIndex: Settings.calendarShowWeekNumbers ? index % 8 : index % 7
                        readonly property int rowIndex: Settings.calendarShowWeekNumbers ? Math.floor(index / 8) : Math.floor(index / 7)
                        readonly property bool weekCell: Settings.calendarShowWeekNumbers && columnIndex === 0
                        readonly property int calendarIndex: Settings.calendarShowWeekNumbers
                                                             ? rowIndex * 7 + columnIndex - 1 : index
                        readonly property date value: root.cellDate(Math.max(0, calendarIndex))
                        readonly property bool inMonth: !weekCell && value.getMonth() === root.shownMonth.getMonth()
                        readonly property bool today: !weekCell && root.isToday(value)

                        Layout.fillWidth: true
                        Layout.preferredHeight: 34
                        radius: 7
                        color: cell.today ? root.appearance.accent
                               : (dayMouse.containsMouse && !cell.weekCell ? root.appearance.surfaceHover : "transparent")

                        Text {
                            anchors.centerIn: parent
                            text: cell.weekCell ? root.isoWeek(root.cellDate(cell.rowIndex * 7)) : cell.value.getDate()
                            color: cell.today ? root.appearance.background
                                   : (cell.weekCell || !cell.inMonth ? root.appearance.textMuted : root.appearance.text)
                            opacity: cell.weekCell ? 0.65 : 1
                            font.family: root.appearance.textFont
                            font.pixelSize: cell.weekCell ? 9 : 11
                            font.weight: cell.today ? Font.DemiBold : Font.Normal
                        }

                        MouseArea {
                            id: dayMouse
                            anchors.fill: parent
                            enabled: !cell.weekCell
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
            CalendarButton {
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 86
                text: "Today"
                appearance: root.appearance
                onClicked: root.shownMonth = new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)
            }
        }
    }

    component CalendarButton: Rectangle {
        id: button
        required property string text
        required property var appearance
        signal clicked
        implicitWidth: 30
        implicitHeight: 28
        radius: 7
        color: buttonMouse.containsMouse ? appearance.surfaceHover : appearance.surface
        Text {
            anchors.centerIn: parent
            text: button.text
            color: button.appearance.text
            font.family: button.appearance.textFont
            font.pixelSize: 11
            font.weight: Font.Medium
        }
        MouseArea {
            id: buttonMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }
}
