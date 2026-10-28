# Security policy

Please report vulnerabilities privately through the repository's [GitHub security advisories](https://github.com/Omgzilla/dms-modelusage/security/advisories/new). Do not include access tokens, refresh tokens, transcript contents, or other credentials in public issues or logs.

This plugin runs as the signed-in desktop user inside Quickshell. It does not need root access and should never be run with `sudo`. Ordinary quota checks are read-only. Applying a supported Codex banked reset consumes a credit only after an account-specific confirmation.

Durable accounting state uses `${XDG_STATE_HOME:-~/.local/state}/dms/model-usage/`. When DMS retains a real legacy `DankMaterialShell` state directory, the plugin uses that real path to preserve history without traversing the migration symlink. Arbitrary symlinks remain rejected. Proxy/T3 credentials are stored separately in `${XDG_CONFIG_HOME:-~/.config}/dms-modelusage/management-keys/` with user-only permissions. Secrets are passed to credential writers over stdin, not as command-line arguments or plugin setting values. Accounting caches retain only usage metadata and hashed identifiers, not prompts, responses, or tool output.

Authenticated HTTP redirects are rejected, TLS certificates are verified, and input/process sizes are bounded. Private writes pin validated directory descriptors and reject symlinked or unsafe paths. Local/T3 costs and live activity fail independently of quota checks.
