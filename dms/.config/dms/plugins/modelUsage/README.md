# dms-modelusage

AI subscription limits, account activity, and estimated API costs in
DMS 2.0 (DuxShell). A port of
[DigitalPals/omarchy-modelusage](https://github.com/DigitalPals/omarchy-modelusage)
with DMS colors, typography, native Material controls, plugin settings, and bar
popouts. Works with
mangowm and other compositors supported by DMS.

## Features

- Local Claude Code, OpenAI Codex, and Kimi Code quotas, reset countdowns,
  credits, and persistent 24H/7D history.
- Fusebox and CLIProxyAPI connections with per-account quotas, private account
  labels, and confirmed Codex banked reset actions where supported.
- Shared Fusebox live session activity and last-used account tracking;
  optional CPA Usage Keeper integration for Go proxies.
- 24H/7D/30D cost estimates from local Codex/Claude transcripts and up to four
  T3 Code servers, with cached prices, custom rates, source diagnostics,
  incremental scans, and duplicate suppression.
- Underlined Limits/Costs tabs, compact provider and metric menus, segmented
  quota meters, and expandable token/model details using the current DMS theme.
- Inline dock expansion, bar font scaling, and collection that pauses when its
  host is hidden and the panel is closed.

See [UPSTREAM.md](UPSTREAM.md) for the incorporated upstream revision and
[configuration](docs/configuration.md) for connection details.

<p>
  <img src="docs/model-usage-limits.png" width="260" alt="Local limits with the DMS palette">
  <img src="docs/model-usage-costs.png" width="260" alt="Cost estimate and expandable breakdowns">
  <img src="docs/model-usage-accounts.png" width="260" alt="Multiple managed Codex accounts">
</p>

Previews use synthetic fixture data and a DMS palette. The installed widget
follows your current DMS theme. Regenerate with `python3 tests/preview docs`.

## Requirements

- DMS 2.0 or newer. This branch targets the 2.0 host APIs; keep your installed
  1.6 plugin until you upgrade DMS.
- Python 3.10 or newer available as `python3`.
- At least one supported CLI installed and signed in, or a configured proxy:
  - Claude Code: `claude auth login`
  - OpenAI Codex: `codex login`
  - Kimi Code: `kimi login`
- Network access for live quotas, public model prices, and configured remote sources.
- Optional: Python `websockets` 15+ for Fusebox live activity (`python-websockets`
  on Arch). Other collectors use Python's standard library.

Provider CLIs own their sign-in and renewal. Missing live dependencies are
reported in the panel; quota checks continue to work.

## Install

Upgrade DMS to 2.0 first. From a local checkout of this branch, install with:

```bash
python3 tests/install
```

The installer checks the DMS version, backs up an existing plugin, and copies
runtime files into the new plugin directory. DMS migrates existing shell
settings and directories during its upgrade. The plugin ID stays `modelUsage`,
preserving settings and bar placement.

For a new installation, clone this branch into DMS 2.0's user plugin directory:

```bash
mkdir -p ~/.config/dms/plugins
git clone --branch v2.0 https://github.com/Omgzilla/dms-modelusage.git \
  ~/.config/dms/plugins/modelUsage
```

Then scan/enable it in DMS Settings → Plugins and add **Model Usage** to your
bar or dock layout. For an already enabled installation:

```bash
dms ipc call plugins reload modelUsage
```

When upgrading from the original port, restart once with `dms restart` if the
reload fails: Quickshell can cache the component directory before the new files
are installed.

The repository name is `dms-modelusage`. Existing installations on this branch
can update with `git pull` if cloned from this repository. See the
[DMS 2.0 compatibility notes](docs/dms-2.0-compatibility.md) for the migration
details and validation scope.

## Configuration

The gear in **Limits** configures providers, proxy connections, private account
labels, bar chips, card corners, polling, and warning thresholds. The gear in
**Costs** configures local history, T3 servers, custom prices, and source
diagnostics. Both forms have explicit Save/Cancel controls and are also
available from DMS's plugin settings.

Costs estimates the public API value of recorded tokens, not subscription
billing. Unknown prices preserve token totals; partial history and unavailable
data are labeled. Local cost sources are independent of the selected quota
provider. Kimi supplies quotas but lacks attributable historical model names
for reliable cost estimates.

State is stored privately under:

```text
${XDG_STATE_HOME:-~/.local/state}/dms/model-usage/
```

Existing history follows DMS's migration. If DMS retains the real legacy
`DankMaterialShell` directory, the plugin continues writing there rather than
following the migration symlink. New proxy/T3 credentials are stored
separately under `${XDG_CONFIG_HOME:-~/.config}/dms-modelusage/management-keys/`
with private permissions. This avoids putting credentials in a symlinked DMS
dotfiles directory or in plugin settings. Provider environment overrides such
as `CLAUDE_CONFIG_DIR`, `CODEX_HOME`, `KIMI_CODE_HOME`, `KIMI_CODE_BASE_URL`,
and `KIMI_SHARE_DIR` are honored.

## Controls

Click the bar widget to open it. In the panel, `c`/`u` switch Costs/Limits,
`r` or Enter refreshes, `s` opens settings, `p` opens the provider menu,
Left/Right select providers, and Up/Down scroll. In Costs, `m` opens the metric
menu, `d` expands token details, and `b` expands model details. Escape closes
the panel or cancels settings. Tab moves through controls.

Namespaced IPC uses Quickshell's active DMS configuration:

```bash
dms ipc call dms-modelusage limits
dms ipc call dms-modelusage costs
dms ipc call dms-modelusage refresh
dms ipc call dms-modelusage configure
dms ipc call dms-modelusage configureCosts
dms ipc call dms-modelusage status
```

With multiple widget instances, these commands select an open panel, then a
visible host. A specific instance is available as `dms-modelusage-<widgetInstanceId>`.

## Development

```bash
python3 tests/run
```

This runs Python and JavaScript regressions plus isolated QML contracts when
Quickshell and DMS 2.0's shared widgets are available. Tests use synthetic accounts and temporary private
state; they do not spend real reset credits. `python3 tests/run --qml-only`
runs only the UI contracts. For a source checkout, point `DMS_SOURCE_DIR` at a
recursive DMS 2.0 checkout (including its shared widget submodule):

```bash
DMS_SOURCE_DIR=/path/to/dux-shell python3 tests/run
DMS_SOURCE_DIR=/path/to/dux-shell python3 tests/dms_host
```

The optional host check needs an existing Wayland session and loads real DMS
host components in an isolated process with temporary settings and fake
collectors. It does not start or upgrade the desktop shell. QML contracts and
previews otherwise run headlessly. See [UPSTREAM.md](UPSTREAM.md).

For a panel-only diagnostic image, open it and call
`dms ipc call dms-modelusage snapshot`. The image is written to
`$XDG_RUNTIME_DIR/dms-modelusage-panel.png`; it includes the panel's displayed
data and follows the account privacy setting.

## Troubleshooting

If a provider is unavailable, run its normal sign-in command in a terminal and press the refresh button. A missing CLI or failed provider is isolated from the other providers.

If the widget does not appear, verify that `plugin.json` is directly inside `~/.config/dms/plugins/modelUsage` and DMS is version 2.0 or newer, then run:

```bash
dms ipc call plugins reload modelUsage
```

Quickshell must inherit a `PATH` containing `python3` and the provider CLIs. If DMS was started by a graphical session with a different environment, use absolute executable paths in your session setup or start DMS after the relevant environment has loaded.

## Attribution

The collectors, accounting, account workflows, and panel design are adapted
from DigitalPals' MIT-licensed plugin. See
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) and [LICENSE](LICENSE).
