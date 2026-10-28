# Upstream tracking

The current port incorporates DigitalPals/omarchy-modelusage at
[`d4986628d0493aa303d02de0d9017237747704ec`](https://github.com/DigitalPals/omarchy-modelusage/commit/d4986628d0493aa303d02de0d9017237747704ec)
(2026-10-08, upstream manifest 1.3.2).

The Python collectors, credential writer, reset state machine, live activity,
local/T3 accounting, and their regression tests follow that revision. Default
state paths follow DMS 2.0's `dms/model-usage` layout, retaining the real legacy
directory where DMS's migration keeps it. New private credentials use
the separate `dms-modelusage` config directory because DMS's directory is often
symlinked to dotfiles. The DMS client
identifies itself as `dms-modelusage`.

`ModelUsagePanel.qml` adapts upstream `Panel.qml`. The shell-specific bar and
popup are provided by `ModelUsage.qml`, using DMS's `PluginComponent` and
`PopoutComponent`. Settings persist through the DMS plugin service. The local
`theme/` adapters supply DMS colors and typography. The `controls/` adapters use
native `DButton`, `DActionButton`, `DTextField`, and `DToggle` from
`qs.DCommon.Widgets` without depending on Omarchy runtime modules.

Host compatibility is pinned to DMS/DuxShell **v2.0.0**,
[`9b413296b16721f7679fb62e624cb1ed2433fa58`](https://github.com/duxlabs-dev/dux-shell/commit/9b413296b16721f7679fb62e624cb1ed2433fa58),
with its DCommon submodule at `ebf5e6c002da1bdaa4aaa2f319fea7b8507abc42`.
See [the compatibility audit](docs/dms-2.0-compatibility.md) for the new host
surfaces, lifecycle, and directory migration.

Keep the DMS plugin ID `modelUsage` and preserve private history across shell
directory migrations when updating. The GitHub repository name is `dms-modelusage`.

The portable tests cover direct providers, Go/Rust proxy APIs, local/T3 cost
accounting, cached prices, private files, redirects, reset confirmation and
retry, and WebSocket activity. QML contracts cover provider refreshes, shared
live connections, cost forms, reset state, and the DMS panel callback. The
optional `tests/dms_host` smoke check also loads the actual DMS 2.0
`PluginComponent` and `PopoutComponent` in an isolated Wayland process.

For future upgrades, compare against this pinned commit, preserve DMS paths and
adapters, update regression fixtures with the behavior they exercise, and run
`python3 tests/run`. Never validate reset actions against a real subscription.
