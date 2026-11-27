# Pi configuration

From the dotfiles checkout, install the personal Pi workflows with:

```sh
mkdir -p "$HOME/.pi/agent/skills" "$HOME/.agents/skills"
stow --dir="$PWD" --target="$HOME" pi
```

On a fresh machine, the `mkdir` step keeps the agent and shared skill directories as real directories. Stow can still link individual packaged skill directories and themes as a unit.

This links `settings.json`, `skills/`, `themes/`, `charm-workflow/`, and `AGENTS.md` from `pi/.pi/agent/` into `~/.pi/agent/`. If Stow reports conflicts from existing local files, back them up and merge any changes before rerunning Stow. It also links the two Git skills into `~/.agents/skills/` without managing other skills there. It does not install Pi. Keep credentials and session history outside this repository. Start Pi (or run `/reload`). The charm workflow uses `/skill:pi-charm-workflow` and still needs its own delegation runner.

## Git workflow

The global instructions route Git work through `git-workflow`, which loads `better-commits` for commit review and drafting. If either skill already exists as a regular file on another machine, back it up and merge any local changes before Stowing this package.

## Dwellir investigations

Pi routes Dwellir investigations to a separate child process. You can also start one explicitly with `/skill:pi-investigate <question>`. The launcher sources `/home/marcus/.config/dwellir/.envrc` on every run and loads the installed `dwellir-investigation` skill. Updates to `.envrc` take effect on the next investigation without a Pi reload. Keep the file local and treat it as trusted Bash code. Its environment is confined to the investigation process and its descendants.

## Charm workflow profile

Edit [`charm-workflow/profile.md`](.pi/agent/charm-workflow/profile.md) to select additional engineering skills per repository. Name the repositories it applies to and the installed skills each role must load. Do not add private repository details or credentials to the shared profile.
