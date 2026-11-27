# Pi configuration

From the dotfiles checkout, install the personal Pi workflows with:

```sh
stow --dir="$PWD" --target="$HOME" pi
```

This links `settings.json`, `skills/`, `themes/`, `charm-workflow/`, and `AGENTS.md` from `pi/.pi/agent/` into `~/.pi/agent/`. If Stow reports conflicts from existing local files, back them up and merge any changes before rerunning Stow. It does not install Pi or manage `~/.agents/skills/`. Keep credentials and session history outside this repository. Start Pi (or run `/reload`). The charm workflow uses `/skill:pi-charm-workflow` and still needs its own delegation runner.

## Dwellir investigations

Pi routes Dwellir investigations to a separate child process. You can also start one explicitly with `/skill:pi-investigate <question>`. The launcher sources `/home/marcus/.config/dwellir/.envrc` on every run and loads the installed `dwellir-investigation` skill. Updates to `.envrc` take effect on the next investigation without a Pi reload. Keep the file local and treat it as trusted Bash code. Its environment is confined to the investigation process and its descendants.

## Charm workflow profile

Edit [`charm-workflow/profile.md`](.pi/agent/charm-workflow/profile.md) to select additional engineering skills per repository. Name the repositories it applies to and the installed skills each role must load. Do not add private repository details or credentials to the shared profile.
