import QtQuick

Item {
    id: root

    required property int tagNumber
    property bool active: false
    property bool occupied: false
    property bool urgent: false
    property string style: "pill"
    property string labelMode: "number"
    property bool showEmpty: true
    property bool showIndicator: true
    property int activeWidth: 31
    property int inactiveWidth: 25
    property int tagHeight: 26
    property int tagRadius: 8
    property int inactiveOpacity: 100
    property string indicatorPosition: "bottom"
    property int activeIndicatorWidth: 9
    property int occupiedIndicatorWidth: 4
    property int indicatorHeight: 2
    property var appearance

    signal activated(int modifiers)
    signal secondaryActivated

    visible: showEmpty || active || occupied || urgent
    implicitWidth: Math.max(12, (active ? activeWidth : inactiveWidth) - (labelMode === "dot" ? 7 : 0))
    implicitHeight: tagHeight
    opacity: active || urgent ? 1 : inactiveOpacity / 100

    function roman(value: int): string {
        const labels = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"];
        return labels[Math.max(0, Math.min(labels.length - 1, value - 1))];
    }

    function displayLabel(): string {
        if (labelMode === "dot") return "●";
        if (labelMode === "roman") return roman(tagNumber);
        return String(tagNumber);
    }

    Behavior on implicitWidth {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }

    Rectangle {
        anchors.fill: parent
        radius: Math.min(root.tagRadius, height / 2)
        color: {
            if (root.style === "minimal")
                return mouseArea.containsMouse ? root.appearance.surfaceHover : "transparent";
            if (root.style === "outline")
                return mouseArea.containsMouse ? root.appearance.surfaceHover : "transparent";
            return root.active ? root.appearance.accent
                               : (mouseArea.containsMouse ? root.appearance.surfaceHover : "transparent");
        }
        border.width: root.style === "outline" && (root.active || root.occupied) ? 1 : 0
        border.color: root.active ? root.appearance.accent : root.appearance.border

        Behavior on color { ColorAnimation { duration: 120 } }
    }

    Text {
        anchors.centerIn: parent
        text: root.displayLabel()
        color: root.style === "pill" && root.active ? root.appearance.background
              : (root.active ? root.appearance.accent
                 : (root.urgent ? root.appearance.urgent : root.appearance.textMuted))
        font.family: root.appearance.textFont
        font.pixelSize: root.labelMode === "dot" ? (root.active ? 9 : 7) : root.appearance.fontSize
        font.weight: root.active ? Math.max(root.appearance.fontWeight, Font.DemiBold)
                                 : root.appearance.fontWeight
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: root.indicatorPosition === "top" ? parent.top : undefined
        anchors.bottom: root.indicatorPosition === "bottom" ? parent.bottom : undefined
        anchors.topMargin: root.indicatorPosition === "top" ? 2 : 0
        anchors.bottomMargin: root.indicatorPosition === "bottom" ? 2 : 0
        width: root.active ? root.activeIndicatorWidth : root.occupiedIndicatorWidth
        height: root.indicatorHeight
        radius: height / 2
        visible: root.showIndicator && root.labelMode !== "dot" && (root.occupied || root.active)
        color: root.style === "pill" && root.active ? root.appearance.background
              : (root.urgent ? root.appearance.urgent : root.appearance.accent)
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) root.secondaryActivated();
            else root.activated(mouse.modifiers);
        }
    }
}
