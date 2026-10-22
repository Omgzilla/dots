# Upstream tracking

The current port incorporates DigitalPals/omarchy-modelusage at
[`d4986628d0493aa303d02de0d9017237747704ec`](https://github.com/DigitalPals/omarchy-modelusage/commit/d4986628d0493aa303d02de0d9017237747704ec)
(2026-10-08, upstream manifest 1.3.2).

The Python collectors, credential writer, reset state machine, live activity,
local/T3 accounting, and their regression tests follow that revision. Default
state paths use `DankMaterialShell/model-usage`; new private credentials use
the separate `dms-modelusage` config directory because DMS's directory is often
symlinked to dotfiles. The DMS client
identifies itself as `dms-modelusage`.

`ModelUsagePanel.qml` adapts upstream `Panel.qml`. The shell-specific bar and
popup are provided by `ModelUsage.qml`, using DMS's `PluginComponent` and
`PopoutComponent`. Settings persist through the DMS plugin service. The local
`theme/` and `controls/` adapters supply DMS colors, fonts, borders, input fields,
buttons and switches without depending on Omarchy runtime modules.

Keep the DMS plugin ID `modelUsage` and the existing private state namespace
when updating. The GitHub repository name is `dms-modelusage`.

The portable tests cover direct providers, Go/Rust proxy APIs, local/T3 cost
accounting, cached prices, private files, redirects, reset confirmation and
retry, and WebSocket activity. QML contracts cover provider refreshes, shared
live connections, cost forms, reset state, and the DMS panel callback.

For future upgrades, compare against this pinned commit, preserve DMS paths and
adapters, update regression fixtures with the behavior they exercise, and run
`python3 tests/run`. Never validate reset actions against a real subscription.
