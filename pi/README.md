# Pi configuration

From the dotfiles checkout, install the personal charm workflow with:

```sh
stow --dir="$PWD" --target="$HOME" --no-folding pi
```

This links only the packaged skill and role prompts; it does not install Pi or configure a subagent runner. Start Pi (or run `/reload`), then invoke `/skill:pi-charm-workflow`.

To select additional engineering skills per repository, create a local `charm-workflow/profile.md` under the Pi agent directory (default `~/.pi/agent`). Name the repositories it applies to and the installed skills each role must load. Keep that profile, credentials, and session history out of this public repository.
