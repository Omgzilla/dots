pragma ComponentBehavior: Bound
import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "modelUsage"
    property string selectedPage: "limits"
    function currentSettings() { return SettingsData.getPluginSettingsForPlugin(pluginId) }
    function commit(form, values) {
        if (!pluginService || !hasPermission) {
            form.errorText = "DMS could not save plugin settings."
            form.finishSave(false)
            return
        }
        for (var key in values) root.saveValue(key, values[key])
        form.finishSave(true)
        form.begin(currentSettings())
    }
    Column {
        width: parent.width
        spacing: Theme.spacingL
        UsageTabs {
            width: parent.width
            value: root.selectedPage
            options: [{value: "limits", label: "Limits"}, {value: "costs", label: "Costs"}]
            onChanged: function(value) { root.selectedPage = value }
        }
        UsageSettings {
            id: limits
            width: parent.width
            visible: root.selectedPage === "limits"
            onSaveRequested: function(values) { root.commit(limits, values) }
            onCancelRequested: begin(root.currentSettings())
        }
        CostSettings {
            id: costs
            width: parent.width
            visible: root.selectedPage === "costs"
            onSaveRequested: function(values) { root.commit(costs, values) }
            onCancelRequested: begin(root.currentSettings())
        }
        SettingsActions {
            width: parent.width
            property var form: root.selectedPage === "limits" ? limits : costs
            errorText: form.errorText
            saving: form.saving
            onSaveRequested: form.submit()
            onCancelRequested: form.begin(root.currentSettings())
        }
        Component.onCompleted: {
            limits.begin(root.currentSettings())
            costs.begin(root.currentSettings())
        }
    }
}
