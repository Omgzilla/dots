import QtQuick
import QtQuick.Layouts
import qs.Services

RowLayout {
    id: root
    required property var barScreen
    required property var appearance
    spacing: Settings.tagSpacing

    Repeater {
        model: MangoService.tagsFor(root.barScreen?.name ?? "")

        TagButton {
            required property var modelData
            required property int index
            tagNumber: modelData.index ?? (index + 1)
            active: modelData.is_active ?? false
            occupied: (modelData.client_count ?? 0) > 0
            urgent: modelData.is_urgent ?? false
            style: Settings.tagStyle
            labelMode: Settings.tagLabelMode
            showEmpty: Settings.tagShowEmpty
            showIndicator: Settings.tagShowIndicators
            activeWidth: Settings.tagActiveWidth
            inactiveWidth: Settings.tagInactiveWidth
            tagHeight: Settings.tagHeight
            tagRadius: Settings.tagRadius
            inactiveOpacity: Settings.tagInactiveOpacity
            indicatorPosition: Settings.tagIndicatorPosition
            activeIndicatorWidth: Settings.tagActiveIndicatorWidth
            occupiedIndicatorWidth: Settings.tagOccupiedIndicatorWidth
            indicatorHeight: Settings.tagIndicatorHeight
            appearance: root.appearance
            onActivated: modifiers => {
                if (modifiers & Qt.ControlModifier)
                    MangoService.toggleTag(root.barScreen.name, tagNumber);
                else
                    MangoService.viewTag(root.barScreen.name, tagNumber);
            }
            onSecondaryActivated: {
                if (!Settings.runWidgetCommand("tags"))
                    MangoService.toggleTag(root.barScreen.name, tagNumber);
            }
        }
    }
}
