# Configuration

Open the widget's gear or DMS Settings → Plugins → Model Usage. Quota and cost
sources have independent settings. Changes take effect after **Save changes**;
Cancel discards the draft, including unsaved credentials.

## Local quotas

Choose **Local CLIs** in Limits and enable the providers you use. Sign in with
`codex login`, `claude auth login`, or `kimi login` in a terminal. Quickshell must
inherit a PATH containing those CLIs and `python3`. The widget reads their
existing credentials and does not renew sign-ins.

Each provider reports its own allowance windows, reset times and optional
credits. The bar shows the most restrictive remaining allowance. Quota history
begins when the widget receives successful readings and survives restarts;
failed refreshes are not recorded as zero usage.

## Fusebox / CLIProxyAPI

In Limits, choose **Fusebox / CLIProxyAPI**, enter the server's HTTP(S) base URL
and Management API key, then save. The widget detects native Fusebox/Rust or
Go CLIProxyAPI. Reverse-proxy path prefixes and management page URLs are
accepted. URLs cannot contain credentials, query strings or fragments.

Use the plaintext management key accepted by the proxy dashboard, not a client
API key or bcrypt hash. Blank replacements keep saved credentials. Remote
servers must allow management access. Account emails are hidden by default.

Managed accounts receive separate quota cards. Collapsed cards show overall
weekly limits where available; **Additional limits** reveals other windows.
Unknown/unsupported quotas remain labeled. Percentages are never added across
subscriptions. The bar uses the last-used account when activity identifies one;
otherwise its tooltip explains the best-capacity account fallback.

Fusebox live activity uses one shared `/api/live` WebSocket per connection and
requires Python `websockets>=15`. On Arch, install `python-websockets` if needed.
Disconnects show **Sessions unknown** and preserve quota readings. Session
counts represent recent account assignments and may remain after completion.
For Go proxies, optional [CPA Usage Keeper](keeper-deployment.md) can supply
last-used account activity. Neither source supplies request-based costs.

## Banked Codex resets

On supported Go proxy accounts, click the banked reset badge to fetch available
credits. Select a credit and explicitly press **Apply reset** to spend it.
Merely opening the confirmation does not apply a reset. Cancel leaves it
unused. Ambiguous network outcomes preserve the same retry identity to prevent
duplicate consumption. Local CLI quotas and native Fusebox do not expose this
action. Availability depends on what the connected account API supports.

## Costs

Enable local Codex/Claude history independently of quota settings. Local paths
are `${CODEX_HOME:-~/.codex}/sessions` and
`${CLAUDE_CONFIG_DIR:-~/.claude}/projects` (including supported nested Claude
layouts). Browser chats and sessions without readable transcripts are absent.

Add up to four T3 Code servers using a name, base URL and connection token.
T3 usage contract 4 or 5 is required. Their exposed folders can include sessions
started outside T3. Matching shared folders count once; copies on separate
machines can still overlap. Offline sources may contribute labeled saved
history. **Last scan** lists included, partial, missing, duplicate and unavailable
sources. Unknown chart periods appear as gaps.

All sources use common API pricing: uncached input, cache reads, cache writes,
and output are priced separately. Reasoning is already part of output. Public
LiteLLM prices are cached daily; explicit refresh requests new prices with a
one-minute minimum between successful downloads. Exact-model custom prices
take precedence; omitted cache prices use input price, while `0` is free.
Ambiguous model aliases stay unpriced. Provider-qualified model prices remain
distinct. Changing prices reprices the selected history.

24H is a rolling window; 7D/30D use calendar days including today in the widget's
timezone. Estimates are API-equivalent value, not invoices or subscription fees.

## Storage and compatibility

State: `${XDG_STATE_HOME:-~/.local/state}/DankMaterialShell/model-usage/`.
Credentials: `${XDG_CONFIG_HOME:-~/.config}/dms-modelusage/management-keys/`.
Existing quota history is retained. Obsolete scan/price caches rebuild once.
The DMS ID remains `modelUsage`; the repository is `dms-modelusage`.

Private storage rejects symlinked path components and unsafe ownership/modes.
Keep credential storage on a private, real directory rather than in a dotfiles
symlink. The DMS settings directory itself may still be symlinked. Configured
proxy keys can also use an existing private regular file via `cliproxyKeyFile`.

Backend payload details: [quotas](backend-contract.md) · [costs](cost-contract.md).
