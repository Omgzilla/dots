# DMS 2.0 compatibility

This branch requires DMS 2.0. The audit used the
[2.0 release notes](https://duxlabs.dev/blog/v2-0-release),
[plugin documentation](https://duxlabs.dev/docs/dms/plugin-development), and
[v2.0.0 source](https://github.com/duxlabs-dev/dux-shell/tree/9b413296b16721f7679fb62e624cb1ed2433fa58).
Its shared widget submodule is pinned to
`ebf5e6c002da1bdaa4aaa2f319fea7b8507abc42`.

## Changes applied

| DMS 2.0 change | Plugin adaptation |
| --- | --- |
| Shared widgets moved to `qs.DCommon.Widgets` and use `D` names | Import the new module and use `DIcon`. Button, action button, input, and switch adapters now use native shared Material controls. |
| Material shapes, spacing, typography, and controls | Use current theme tokens for spacing, corners, button heights, and display text. Colors continue to follow the active DMS palette, including selected text contrast. |
| Host font scaling | Percentage labels use `PluginComponent.textSize`; icons continue using the host's `iconSize`. |
| Bar/dock visibility and interaction lifecycle | Automatic quota polling and live activity pause when the host is inactive and its panel is closed. Manual IPC refresh remains available. |
| Inline dock plugin expansion | Reuse the existing panel through `attachedContent`, with `interactionActive` driving its open state. |
| Multiple host instances | Give each widget an IPC target and retain one shared `dms-modelusage` alias that routes to an open or visible panel. |
| Config/state directories renamed to `dms` | Install under `~/.config/dms/plugins/modelUsage`; preserve history in the actual state directory across both migration layouts. |
| Shell app ID changed to `dev.duxlabs.shell` | No old shell app ID is embedded in the plugin. IPC continues through the `dms` CLI. |

New Dash cards, lyrics providers, and lockscreen surfaces are optional APIs;
the bar/dock usage widget does not require those integrations. MangoWC's
configuration migration belongs to the DMS/compositor upgrade and does not
require plugin-specific configuration changes.

## Upgrade order

1. Keep the existing plugin while running DMS 1.6.
2. Upgrade DMS to 2.0 using its normal upgrade process; let DMS migrate its
   directories and shell settings.
3. Run `python3 tests/install` from this branch. It checks the DMS version
   before copying anything and backs up an existing plugin.
4. Run `dms ipc call plugins reload modelUsage`. If Quickshell has cached the
   previous component layout, use `dms restart` once.

The plugin ID and settings keys are unchanged. New state uses
`${XDG_STATE_HOME:-~/.local/state}/dms/model-usage/`. If DMS keeps the real
`DankMaterialShell` directory and makes `dms` its relative compatibility alias,
the plugin uses that real legacy directory instead. It does not follow an
arbitrary symlink or weaken private-file checks. This matches the
[shell's migration code](https://github.com/duxlabs-dev/dux-shell/blob/9b413296b16721f7679fb62e624cb1ed2433fa58/core/internal/utils/dirs.go).
The separate private `dms-modelusage/management-keys` directory is unchanged.

## Validation

`tests/run` covers collectors, accounting, private storage, both directory
migration layouts, installation version checks, and isolated QML contracts.
QML contracts and fixture previews use the actual shared widgets from the
pinned release, with a deterministic theme and synthetic account data.
CI checks out the same release and submodule for the QML job.

`tests/dms_host` additionally loads the actual 2.0 host components and checks
bar icon height, font scaling, inactive collection, and inline dock interaction.
It needs an existing Wayland session and a recursive source checkout supplied
through `DMS_SOURCE_DIR`. It uses temporary XDG directories, fake collectors,
and no DMS backend. It does not replace or launch the desktop shell.

These checks validate the plugin APIs and behavior. A full interactive desktop
session on the upgraded shell remains a separate post-upgrade check.
