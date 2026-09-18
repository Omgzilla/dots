pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import "UsageLogic.js" as UsageLogic

PluginComponent {
    id: root

    layerNamespacePlugin: "model-usage"

    readonly property var providers: backend.providers
    property string selectedProviderId: ""
    property string historyMode: "h24"
    property string viewMode: "limits"
    property double nowMs: Date.now()
    readonly property color foreground: Theme.surfaceText
    readonly property color secondaryForeground: Theme.surfaceTextMedium
    readonly property color accent: Theme.primary
    readonly property color barForeground: Theme.widgetTextColor
    readonly property color barIcon: Theme.widgetIconColor

    readonly property int criticalThreshold: UsageLogic.clamp(
        setting("criticalThreshold", 10), 0, 100)
    readonly property int warningThreshold: Math.max(criticalThreshold,
        UsageLogic.clamp(setting("warningThreshold", 25), 0, 100))
    readonly property string displayMode: String(setting("barDisplayMode", "Icon"))
    readonly property var percentageProviders: UsageLogic.meaningfulProviders(providers)
    readonly property bool percentageMode: displayMode === "Percentages"
        && !root.isVertical && percentageProviders.length > 0
    readonly property bool alarming: anyProviderAlarming()
    readonly property int providerIndex: {
        for (var i = 0; i < providers.length; i++) {
            if (providers[i].id === selectedProviderId)
                return i
        }
        return 0
    }
    readonly property var provider: providers.length > 0 ? providers[providerIndex] : null

    function setting(name, fallback) {
        var value = root.pluginData ? root.pluginData[name] : undefined
        return value === undefined || value === null ? fallback : value
    }

    function alpha(color, opacity) {
        return Theme.withAlpha(color, opacity)
    }

    function anyProviderAlarming() {
        for (var i = 0; i < providers.length; i++) {
            var severity = UsageLogic.severity(providers[i], warningThreshold, criticalThreshold)
            if (severity === "warning" || severity === "critical")
                return true
        }
        return false
    }

    function ensureSelection() {
        if (providers.length === 0) {
            selectedProviderId = ""
            return
        }
        for (var i = 0; i < providers.length; i++) {
            if (providers[i].id === selectedProviderId)
                return
        }
        selectedProviderId = String(providers[0].id)
    }

    function selectProvider(index) {
        if (providers.length === 0)
            return
        var wrapped = ((index % providers.length) + providers.length) % providers.length
        selectedProviderId = String(providers[wrapped].id)
    }

    function selectProviderId(providerId) {
        for (var i = 0; i < providers.length; i++) {
            if (providers[i].id === providerId) {
                selectProvider(i)
                return
            }
        }
    }

    function nextProvider() {
        selectProvider(providerIndex + 1)
    }

    function refreshNow() {
        if (viewMode === "costs")
            costBackend.refresh()
        else
            backend.refresh()
    }

    function showLimits() {
        viewMode = "limits"
    }

    function showCosts() {
        viewMode = "costs"
        costBackend.ensureLoaded()
    }

    function windowSeverity(window) {
        if (!window)
            return "none"
        var remaining = Number(window.remaining)
        if (!isFinite(remaining))
            return "none"
        if (remaining <= criticalThreshold)
            return "critical"
        if (remaining <= warningThreshold)
            return "warning"
        return "ok"
    }

    function durationUntil(epochSeconds) {
        var seconds = Number(epochSeconds)
        if (!isFinite(seconds) || seconds <= 0)
            return ""
        var remaining = Math.floor(seconds - nowMs / 1000)
        if (remaining <= 0)
            return "now"
        var days = Math.floor(remaining / 86400)
        var hours = Math.floor((remaining % 86400) / 3600)
        var minutes = Math.floor((remaining % 3600) / 60)
        var secs = remaining % 60
        if (days > 0)
            return days + "d " + hours + "h"
        if (hours > 0)
            return hours + "h " + minutes + "m"
        if (minutes > 0)
            return minutes + "m " + secs + "s"
        return Math.max(1, secs) + "s"
    }

    function absoluteReset(epochSeconds) {
        var seconds = Number(epochSeconds)
        if (!isFinite(seconds) || seconds <= 0)
            return ""
        var date = new Date(seconds * 1000)
        return seconds * 1000 - nowMs < 86400000
            ? Qt.formatTime(date, "HH:mm")
            : Qt.formatDateTime(date, "MMM d, HH:mm")
    }

    function resetText(window) {
        if (!window || !window.resetsAt)
            return ""
        var relative = durationUntil(window.resetsAt)
        var absolute = absoluteReset(window.resetsAt)
        if (relative === "")
            return ""
        return "Resets in " + relative + (absolute !== "" ? " · " + absolute : "")
    }

    function heroMeta(provider) {
        return provider && provider.plan ? String(provider.plan) : ""
    }

    function accountDetails(provider) {
        if (!provider)
            return ""
        var lines = []
        if (provider.account)
            lines.push("Account: " + String(provider.account))
        if (provider.source)
            lines.push("Source: " + String(provider.source))
        return lines.join(" · ")
    }

    function iconUrl(provider) {
        if (!provider)
            return ""
        if (provider.id === "codex") {
            return Qt.resolvedUrl(Theme.isLightMode
                ? "assets/codex-light.svg" : "assets/codex.svg")
        }
        return Qt.resolvedUrl("assets/" + provider.id + ".svg")
    }

    function barIconUrl(provider) {
        if (!provider)
            return ""
        return Qt.resolvedUrl("assets/" + provider.id + "-bar.svg")
    }

    function creditsPrimary(credits) {
        if (!credits)
            return ""
        if (credits.remaining !== null && credits.remaining !== undefined)
            return formatAmount(credits.remaining, credits.currency) + " remaining"
        if (credits.unlimited)
            return "Unlimited"
        if (credits.used !== null && credits.used !== undefined)
            return formatAmount(credits.used, credits.currency) + " used"
        if (credits.resetCreditsAvailable !== null
            && credits.resetCreditsAvailable !== undefined) {
            return credits.resetCreditsAvailable + " reset credit"
                + (credits.resetCreditsAvailable === 1 ? "" : "s")
        }
        return "Available"
    }

    function creditsDetail(credits) {
        if (!credits)
            return ""
        var parts = []
        if (credits.used !== null && credits.used !== undefined) {
            if (credits.limit !== null && credits.limit !== undefined) {
                parts.push(formatAmount(credits.used, credits.currency) + " used of "
                    + formatAmount(credits.limit, credits.currency))
            } else {
                parts.push(formatAmount(credits.used, credits.currency) + " used this month")
            }
        }
        if (credits.unlimited && credits.remaining !== null
            && credits.remaining !== undefined)
            parts.push("No monthly spending cap")
        if (credits.total !== null && credits.total !== undefined)
            parts.push(formatAmount(credits.total, credits.currency) + " funded")
        if (credits.resetCreditsAvailable !== null
            && credits.resetCreditsAvailable !== undefined) {
            parts.push(credits.resetCreditsAvailable + " rate-limit reset credit"
                + (credits.resetCreditsAvailable === 1 ? "" : "s"))
        }
        return parts.join(" · ")
    }

    function currencyPrefix(currency) {
        var value = String(currency || "").toUpperCase()
        if (value === "USD") return "$"
        if (value === "EUR") return "€"
        if (value === "GBP") return "£"
        if (value === "CNY") return "¥"
        return value === "" ? "" : value + " "
    }

    function formatAmount(value, currency) {
        var amount = Number(value)
        if (!isFinite(amount))
            return "—"
        var digits = Math.abs(amount - Math.round(amount)) < 0.001 ? 0 : 2
        return currencyPrefix(currency) + amount.toFixed(digits)
    }

    function errorBody(provider) {
        if (!provider)
            return ""
        var message = String(provider.message || "Usage data is unavailable.")
        if (provider.errorKind === "no_credentials" || provider.errorKind === "expired")
            message += " Run “" + provider.authCommand + "” in a terminal, then refresh."
        return message
    }

    function footerLeft() {
        if (viewMode === "costs") {
            if (costBackend.fetchError !== "")
                return costBackend.fetchError
            if (costBackend.lastSuccessAt > 0)
                return "Updated " + Qt.formatTime(new Date(costBackend.lastSuccessAt), "HH:mm:ss")
            return costBackend.loading ? "Scanning transcripts…" : "Open Costs to scan local activity"
        }
        if (backend.fetchError !== "")
            return backend.fetchError
        if (backend.lastSuccessAt > 0)
            return "Updated " + Qt.formatTime(new Date(backend.lastSuccessAt), "HH:mm:ss")
        return backend.loading ? "Refreshing…" : "Waiting for first refresh"
    }

    function footerRight() {
        if (viewMode === "costs") {
            var duration = costBackend.payload ? Number(costBackend.payload.scanDurationMs) : 0
            return duration > 0 ? "Scan " + duration + "ms" : ""
        }
        if (backend.nextRefreshAt <= 0)
            return ""
        var seconds = Math.max(0, Math.floor((backend.nextRefreshAt - nowMs) / 1000))
        var minutes = Math.floor(seconds / 60)
        var remainder = String(seconds % 60).padStart(2, "0")
        return "Next " + minutes + ":" + remainder
    }

    onProvidersChanged: ensureSelection()
    onViewModeChanged: {
        if (viewMode === "costs")
            costBackend.ensureLoaded()
    }

    UsageBackend {
        id: backend
        settings: root.pluginData
    }

    CostBackend {
        id: costBackend
        settings: root.pluginData
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.nowMs = Date.now()
    }

    horizontalBarPill: Component {
        Item {
            implicitWidth: root.percentageMode
                ? percentageRow.implicitWidth : iconRow.implicitWidth
            implicitHeight: Math.max(percentageRow.implicitHeight, iconRow.implicitHeight)

            Row {
                id: iconRow
                visible: !root.percentageMode
                spacing: Theme.spacingXS

                DankIcon {
                    name: "data_usage"
                    size: root.iconSize
                    color: root.alarming ? Theme.error : root.barIcon
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                id: percentageRow
                visible: root.percentageMode
                spacing: Theme.spacingXXS

                Repeater {
                    model: root.percentageProviders

                    delegate: Item {
                        required property var modelData

                        readonly property real remainingValue: UsageLogic.minRemaining(modelData)
                        readonly property string remainingText: remainingValue === null
                            ? "—" : Math.round(remainingValue) + "%"
                        readonly property string severity: UsageLogic.severity(
                            modelData, root.warningThreshold, root.criticalThreshold)
                        readonly property bool stressed: severity === "warning"
                            || severity === "critical"

                        implicitWidth: mark.width + label.implicitWidth + Theme.spacingS
                        width: implicitWidth
                        height: root.iconSize + Theme.spacingXS

                        Item {
                            id: mark
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: root.iconSize - 6
                            height: width

                            Image {
                                id: markImage
                                anchors.fill: parent
                                source: root.barIconUrl(modelData)
                                sourceSize.width: width * 2
                                sourceSize.height: height * 2
                                fillMode: Image.PreserveAspectFit
                                visible: false
                                layer.enabled: true
                            }

                            MultiEffect {
                                anchors.fill: markImage
                                source: markImage
                                visible: markImage.status === Image.Ready
                                colorization: 1
                                colorizationColor: stressed ? Theme.error : root.barIcon
                            }

                            StyledText {
                                anchors.centerIn: parent
                                visible: markImage.status !== Image.Ready
                                text: UsageLogic.providerMark(String(modelData.id))
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Bold
                                color: stressed ? Theme.error : root.barIcon
                            }
                        }

                        StyledText {
                            id: label
                            anchors.left: mark.right
                            anchors.leftMargin: Theme.spacingXS
                            anchors.verticalCenter: parent.verticalCenter
                            text: remainingText
                            font.pixelSize: Theme.fontSizeMedium
                            font.weight: Font.DemiBold
                            color: stressed ? Theme.error : root.barForeground
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.selectProviderId(String(modelData.id))
                                root.triggerPopout()
                            }
                        }
                    }
                }
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: "data_usage"
                size: root.iconSize
                color: root.alarming ? Theme.error : root.barIcon
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popup

            headerText: root.viewMode === "costs"
                ? "Estimated Costs"
                : (root.provider ? String(root.provider.name) : "Model Usage")
            detailsText: root.viewMode === "costs"
                ? "API-equivalent value from local CLI transcripts"
                : "Subscription limits, reset times, and local usage history"
            showCloseButton: true
            focus: true

            Item {
                id: viewport
                width: parent.width
                implicitHeight: Math.max(280, root.popoutHeight - popup.headerHeight
                    - popup.detailsHeight - Theme.spacingL * 2)
                height: implicitHeight

                Flickable {
                    id: flick
                    anchors.fill: parent
                    contentWidth: width
                    contentHeight: contentColumn.implicitHeight
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.VerticalFlick
                    interactive: contentHeight > height

                    Column {
                        id: contentColumn
                        width: flick.width
                        spacing: Theme.spacingL

                        Row {
                            width: parent.width
                            spacing: Theme.spacingXS

                            Rectangle {
                                width: (parent.width - Theme.spacingXS) / 2
                                height: 36
                                radius: Theme.cornerRadius
                                color: root.viewMode === "limits"
                                    ? root.accent : Theme.surfaceContainerHigh
                                border.width: 1
                                border.color: root.viewMode === "limits"
                                    ? root.accent : Theme.outline

                                StyledText {
                                    anchors.centerIn: parent
                                    text: "Limits"
                                    font.pixelSize: Theme.fontSizeSmall
                                    font.weight: Font.Medium
                                    color: root.viewMode === "limits"
                                        ? Theme.primaryText : Theme.surfaceText
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.showLimits()
                                }
                            }

                            Rectangle {
                                width: (parent.width - Theme.spacingXS) / 2
                                height: 36
                                radius: Theme.cornerRadius
                                color: root.viewMode === "costs"
                                    ? root.accent : Theme.surfaceContainerHigh
                                border.width: 1
                                border.color: root.viewMode === "costs"
                                    ? root.accent : Theme.outline

                                StyledText {
                                    anchors.centerIn: parent
                                    text: "Costs"
                                    font.pixelSize: Theme.fontSizeSmall
                                    font.weight: Font.Medium
                                    color: root.viewMode === "costs"
                                        ? Theme.primaryText : Theme.surfaceText
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.showCosts()
                                }
                            }
                        }

                        Flow {
                            visible: root.viewMode === "limits" && root.providers.length > 1
                            width: parent.width
                            spacing: Theme.spacingXS

                            Repeater {
                                model: root.providers

                                delegate: Rectangle {
                                    required property var modelData

                                    width: providerName.implicitWidth + Theme.spacingL * 2
                                    height: 32
                                    radius: Theme.cornerRadius
                                    color: root.provider
                                        && root.provider.id === modelData.id
                                        ? root.accent : Theme.surfaceContainerHigh
                                    border.width: 1
                                    border.color: root.provider
                                        && root.provider.id === modelData.id
                                        ? root.accent : Theme.outline

                                    StyledText {
                                        id: providerName
                                        anchors.centerIn: parent
                                        text: String(modelData.name || modelData.id)
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: root.provider
                                            && root.provider.id === modelData.id
                                            ? Theme.primaryText : Theme.surfaceText
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.selectProviderId(String(modelData.id))
                                    }
                                }
                            }
                        }

                        Column {
                            visible: root.viewMode === "limits"
                            width: parent.width
                            spacing: Theme.spacingL

                            Rectangle {
                                visible: !!root.provider
                                width: parent.width
                                height: heroContent.implicitHeight + Theme.spacingL * 2
                                radius: Theme.cornerRadius
                                color: Theme.surfaceContainer
                                border.width: 1
                                border.color: Theme.withAlpha(root.foreground, 0.14)

                                Row {
                                    id: heroContent
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.margins: Theme.spacingL
                                    spacing: Theme.spacingM

                                    Item {
                                        width: 42
                                        height: 42
                                        anchors.verticalCenter: parent.verticalCenter

                                        Image {
                                            id: heroImage
                                            anchors.fill: parent
                                            source: root.iconUrl(root.provider)
                                            sourceSize.width: width * 2
                                            sourceSize.height: height * 2
                                            fillMode: Image.PreserveAspectFit
                                            visible: status === Image.Ready
                                        }

                                        StyledText {
                                            anchors.centerIn: parent
                                            visible: heroImage.status !== Image.Ready
                                            text: UsageLogic.providerMark(root.provider
                                                ? String(root.provider.id) : "")
                                            font.pixelSize: Theme.fontSizeXLarge
                                            font.weight: Font.Bold
                                            color: root.accent
                                        }
                                    }

                                    Column {
                                        width: Math.max(0, parent.width - 42 - actionRow.width
                                            - parent.spacing)
                                        spacing: Theme.spacingXXS
                                        anchors.verticalCenter: parent.verticalCenter

                                        StyledText {
                                            width: parent.width
                                            text: root.provider ? String(root.provider.name) : "Model Usage"
                                            font.pixelSize: Theme.fontSizeLarge
                                            font.weight: Font.DemiBold
                                            color: Theme.surfaceText
                                            elide: Text.ElideRight
                                        }

                                        StyledText {
                                            width: parent.width
                                            text: root.heroMeta(root.provider)
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: root.secondaryForeground
                                            elide: Text.ElideRight
                                        }

                                        StyledText {
                                            visible: root.accountDetails(root.provider) !== ""
                                            width: parent.width
                                            text: root.accountDetails(root.provider)
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: root.secondaryForeground
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Row {
                                        id: actionRow
                                        spacing: Theme.spacingXS
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            width: 36
                                            height: 36
                                            radius: Theme.cornerRadius
                                            color: refreshArea.containsMouse
                                                ? Theme.primaryHover : Theme.surfaceContainerHigh
                                            border.width: 1
                                            border.color: Theme.outline

                                            DankIcon {
                                                anchors.centerIn: parent
                                                name: "refresh"
                                                size: Theme.iconSizeSmall
                                                color: Theme.surfaceText
                                            }

                                            MouseArea {
                                                id: refreshArea
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                enabled: !backend.loading
                                                onClicked: root.refreshNow()
                                            }
                                        }
                                    }
                                }
                            }

                            StyledText {
                                visible: root.providers.length === 0
                                width: parent.width
                                topPadding: Theme.spacingXL
                                bottomPadding: Theme.spacingXL
                                text: backend.loading
                                    ? "Loading AI subscription usage…"
                                    : "No providers are enabled. Enable Claude, Codex, or Kimi in the widget settings."
                                color: root.secondaryForeground
                                font.pixelSize: Theme.fontSizeMedium
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                            }

                            Rectangle {
                                visible: !!root.provider && root.provider.status !== "ok"
                                width: parent.width
                                height: errorColumn.implicitHeight + Theme.spacingL * 2
                                radius: Theme.cornerRadius
                                color: root.alpha(Theme.error, 0.09)
                                border.width: 1
                                border.color: root.alpha(Theme.error, 0.4)

                                Column {
                                    id: errorColumn
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.margins: Theme.spacingL
                                    spacing: Theme.spacingXS

                                    StyledText {
                                        width: parent.width
                                        text: UsageLogic.errorTitle(root.provider)
                                        color: Theme.error
                                        font.pixelSize: Theme.fontSizeMedium
                                        font.weight: Font.Bold
                                        wrapMode: Text.WordWrap
                                    }

                                    StyledText {
                                        width: parent.width
                                        text: root.errorBody(root.provider)
                                        color: root.secondaryForeground
                                        font.pixelSize: Theme.fontSizeSmall
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            StyledText {
                                visible: !!root.provider && root.provider.status === "ok"
                                    && String(root.provider.notice || "") !== ""
                                width: parent.width
                                text: root.provider ? String(root.provider.notice || "") : ""
                                color: root.secondaryForeground
                                font.pixelSize: Theme.fontSizeSmall
                                wrapMode: Text.WordWrap
                            }

                            Column {
                                visible: !!root.provider && root.provider.status === "ok"
                                    && UsageLogic.isListLike(root.provider.windows)
                                    && root.provider.windows.length > 0
                                width: parent.width
                                spacing: Theme.spacingL

                                StyledText {
                                    text: "USAGE LIMITS"
                                    font.pixelSize: Theme.fontSizeSmall
                                    font.weight: Font.Bold
                                    color: root.foreground
                                }

                                Repeater {
                                    model: root.provider ? UsageLogic.listOrEmpty(
                                        root.provider.windows) : []

                                    delegate: Rectangle {
                                        required property var modelData

                                        readonly property string severity: root.windowSeverity(modelData)
                                        readonly property bool stressed: severity === "warning"
                                            || severity === "critical"
                                        width: parent.width
                                        height: limitContent.implicitHeight + Theme.spacingL * 2
                                        radius: Theme.cornerRadius
                                        color: severity === "critical"
                                            ? root.alpha(Theme.error, 0.09)
                                            : Theme.surfaceContainer
                                        border.width: 1
                                        border.color: stressed
                                            ? root.alpha(Theme.error, 0.4) : Theme.outline

                                        Column {
                                            id: limitContent
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.margins: Theme.spacingL
                                            spacing: Theme.spacingS

                                            Item {
                                                width: parent.width
                                                implicitHeight: Math.max(limitLabel.implicitHeight,
                                                    limitPercent.implicitHeight)

                                                StyledText {
                                                    id: limitLabel
                                                    anchors.left: parent.left
                                                    anchors.right: limitPercent.left
                                                    anchors.rightMargin: Theme.spacingM
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    text: String(modelData.label || "Usage limit")
                                                    color: root.foreground
                                                    font.pixelSize: Theme.fontSizeMedium
                                                    font.weight: Font.Medium
                                                    elide: Text.ElideRight
                                                }

                                                StyledText {
                                                    id: limitPercent
                                                    anchors.right: parent.right
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    text: isFinite(Number(modelData.remaining))
                                                        ? Math.round(Number(modelData.remaining))
                                                            + "% left" : "—"
                                                    color: stressed ? Theme.error : root.foreground
                                                    font.pixelSize: Theme.fontSizeSmall
                                                    font.weight: stressed ? Font.Bold : Font.Normal
                                                }
                                            }

                                            BlockMeter {
                                                width: parent.width
                                                height: 8
                                                value: Number(modelData.remaining) / 100
                                                fillColor: stressed ? Theme.error : root.accent
                                                trackColor: root.alpha(root.foreground, 0.14)
                                            }

                                            StyledText {
                                                visible: text !== ""
                                                width: parent.width
                                                text: root.resetText(modelData)
                                                color: root.secondaryForeground
                                                font.pixelSize: Theme.fontSizeSmall
                                                elide: Text.ElideRight
                                            }

                                            StyledText {
                                                visible: text !== ""
                                                width: parent.width
                                                text: String(modelData.detail || "")
                                                color: root.secondaryForeground
                                                font.pixelSize: Theme.fontSizeSmall
                                                elide: Text.ElideRight
                                            }
                                        }
                                    }
                                }
                            }

                            Column {
                                id: creditsSection
                                visible: !!root.provider && root.provider.status === "ok"
                                    && !!creditsSection.creditData
                                width: parent.width
                                spacing: Theme.spacingL

                                readonly property var creditData: root.provider
                                    ? root.provider.credits : null

                                StyledText {
                                    text: creditsSection.creditData
                                        ? String(creditsSection.creditData.label || "CREDITS").toUpperCase()
                                        : "CREDITS"
                                    font.pixelSize: Theme.fontSizeSmall
                                    font.weight: Font.Bold
                                    color: root.foreground
                                }

                                Rectangle {
                                    id: creditsCard
                                    property bool hasMeter: !!creditsSection.creditData
                                        && creditsSection.creditData.used !== null
                                        && creditsSection.creditData.used !== undefined
                                        && creditsSection.creditData.limit !== null
                                        && creditsSection.creditData.limit !== undefined
                                        && Number(creditsSection.creditData.limit) > 0
                                    width: parent.width
                                    height: creditsContent.implicitHeight + Theme.spacingL * 2
                                    radius: Theme.cornerRadius
                                    color: Theme.surfaceContainer
                                    border.width: 1
                                    border.color: Theme.outline

                                    Column {
                                        id: creditsContent
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.margins: Theme.spacingL
                                        spacing: Theme.spacingS

                                        StyledText {
                                            width: parent.width
                                            text: root.creditsPrimary(creditsSection.creditData)
                                            color: root.foreground
                                            font.pixelSize: Theme.fontSizeXLarge
                                            font.weight: Font.Bold
                                            elide: Text.ElideRight
                                        }

                                        StyledText {
                                            visible: creditsCard.hasMeter
                                            width: parent.width
                                            text: creditsCard.hasMeter
                                                ? "MONTHLY ALLOWANCE · "
                                                    + Math.round(Number(creditsSection.creditData.used)
                                                        / Number(creditsSection.creditData.limit) * 100)
                                                    + "% USED" : ""
                                            color: root.secondaryForeground
                                            font.pixelSize: Theme.fontSizeSmall
                                            elide: Text.ElideRight
                                        }

                                        BlockMeter {
                                            visible: creditsCard.hasMeter
                                            width: parent.width
                                            height: 8
                                            value: creditsCard.hasMeter
                                                ? Number(creditsSection.creditData.used)
                                                    / Number(creditsSection.creditData.limit) : 0
                                            fillColor: root.accent
                                            trackColor: root.alpha(root.foreground, 0.14)
                                        }

                                        StyledText {
                                            visible: text !== ""
                                            width: parent.width
                                            text: root.creditsDetail(creditsSection.creditData)
                                            color: root.secondaryForeground
                                            font.pixelSize: Theme.fontSizeSmall
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }

                            UsageHistory {
                                visible: !!root.provider && !!root.provider.history
                                    && ((UsageLogic.isListLike(root.provider.history.h24)
                                        && root.provider.history.h24.length > 0)
                                        || (UsageLogic.isListLike(root.provider.history.d7)
                                            && root.provider.history.d7.length > 0))
                                width: parent.width
                                history: root.provider ? root.provider.history
                                    : ({ h24: [], d7: [] })
                                mode: root.historyMode
                                foreground: root.foreground
                                onModeChanged: root.historyMode = mode
                            }
                        }

                        UsageCosts {
                            visible: root.viewMode === "costs"
                            width: parent.width
                            payload: costBackend.payload
                            loading: costBackend.loading
                            errorText: costBackend.fetchError
                            periodDays: costBackend.periodDays
                            foreground: root.foreground
                            urgent: Theme.error
                            surface: Theme.surfaceContainer
                            onPeriodRequested: function(days) {
                                costBackend.selectPeriod(days)
                            }
                        }

                        Item {
                            width: parent.width
                            implicitHeight: Math.max(footerLeft.implicitHeight,
                                footerRight.implicitHeight)

                            StyledText {
                                id: footerLeft
                                anchors.left: parent.left
                                anchors.right: footerRight.left
                                anchors.rightMargin: Theme.spacingM
                                text: root.footerLeft()
                                color: (root.viewMode === "costs"
                                    ? costBackend.fetchError : backend.fetchError) !== ""
                                    ? Theme.error : root.secondaryForeground
                                font.pixelSize: Theme.fontSizeSmall
                                elide: Text.ElideRight
                            }

                            StyledText {
                                id: footerRight
                                anchors.right: parent.right
                                text: root.footerRight()
                                color: root.secondaryForeground
                                font.pixelSize: Theme.fontSizeSmall
                            }
                        }
                    }
                }
            }
        }

    }

    popoutWidth: 480
    popoutHeight: 720
}
