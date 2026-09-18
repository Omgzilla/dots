# Model Usage for DankMaterialShell

A DankMaterialShell widget port of [DigitalPals/omarchy-modelusage](https://github.com/DigitalPals/omarchy-modelusage). It shows Claude Code, OpenAI Codex, and Kimi Code subscription limits, reset times, credits, quota history, and on-demand API-equivalent cost estimates from local CLI transcripts.

The port keeps the upstream provider collectors and cost scanner, but replaces Omarchy Quattro's panel APIs with DMS's `PluginComponent`, `PopoutComponent`, and `PluginSettings` APIs. It does not require Omarchy or a particular window manager.

## Requirements

- DankMaterialShell 1.6 or newer.
- Python 3.10 or newer available as `python3`.
- At least one supported CLI installed and signed in:
  - Claude Code: `claude auth login`
  - OpenAI Codex: `codex login`
  - Kimi Code: `kimi login`
- Network access for live quota checks. The Costs tab reads local transcripts and may download the public LiteLLM price table once per day.

The collectors use only Python's standard library. They read credentials owned by the provider CLIs and do not print or copy tokens.

## Install

Copy this checkout into DMS's user plugin directory:

```bash
mkdir -p ~/.config/DankMaterialShell/plugins
cp -a /path/to/dms-model-usage-plugin/. \
  ~/.config/DankMaterialShell/plugins/modelUsage/
```

If you publish your own fork, cloning that fork into the same `modelUsage` directory works too. Then reload the plugin and add it to DankBar:

```bash
dms ipc call plugins reload modelUsage
```

Open DMS Settings → Appearance → DankBar Layout, add **Model Usage** to a bar section, and click its icon. The widget can also be enabled from DMS's plugin settings page.

The manifest uses the DMS-valid camelCase id `modelUsage`; the original Omarchy id `digitalpals.model-usage` is not a valid DMS plugin id.

## Configuration

The plugin settings panel provides:

- enabled providers;
- a 1-minute to 1-hour refresh interval;
- icon or compact percentage bar display;
- warning and critical remaining-quota thresholds.

The widget popup provides Limits and Costs views. Costs are an estimate of public API value for locally recorded tokens, not subscription billing. Unknown pricing is shown as unavailable rather than guessed.

State is stored privately under:

```text
${XDG_STATE_HOME:-~/.local/state}/DankMaterialShell/model-usage/
```

The state contains bounded quota history, sanitized transcript scan metadata, and cached public model prices. Provider-specific CLI environment overrides such as `CLAUDE_CONFIG_DIR`, `CODEX_HOME`, `KIMI_CODE_HOME`, `KIMI_CODE_BASE_URL`, and `KIMI_SHARE_DIR` are honored.

## Troubleshooting

If a provider is unavailable, run its normal sign-in command in a terminal and press the refresh button. A missing CLI or failed provider is isolated from the other providers.

If the widget does not appear, verify that `plugin.json` is directly inside `~/.config/DankMaterialShell/plugins/modelUsage`, then run:

```bash
dms ipc call plugins reload modelUsage
```

Quickshell must inherit a `PATH` containing `python3` and the provider CLIs. If DMS was started by a graphical session with a different environment, use absolute executable paths in your session setup or start DMS after the relevant environment has loaded.

## Attribution

The backend collectors, cost scanner, provider normalization, and original usage design are adapted from DigitalPals' MIT-licensed Omarchy Model Usage plugin. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) and [LICENSE](LICENSE).
