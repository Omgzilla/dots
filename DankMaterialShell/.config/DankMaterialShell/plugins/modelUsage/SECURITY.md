# Security policy

Please report vulnerabilities privately through the repository's [GitHub security advisories](https://github.com/DigitalPals/omarchy-modelusage/security/advisories/new). Do not include access tokens, refresh tokens, transcript contents, or other credentials in public issues or logs.

This plugin runs as the signed-in desktop user inside Quickshell. It does not need root access and should never be run with `sudo`. The Python helpers read provider-owned credentials for read-only quota requests and scan local usage metadata. Durable state is stored below `${XDG_STATE_HOME:-~/.local/state}/DankMaterialShell/model-usage/`; prompts, responses, tool calls, tool results, and credentials are not cached.
