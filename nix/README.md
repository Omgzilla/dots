# Nix-darwin configuration

This is the same configuration split by responsibility. It remains one flake,
one `flake.lock`, and one rebuild command.

| Location | Owns |
| --- | --- |
| `flake.nix` | Inputs and assembly of the Darwin system |
| `hosts/omg-mac/default.nix` | Mac-specific identity and Nix ownership |
| `modules/packages.nix` | Nix-installed CLI tools and `nix-upgrade` |
| `modules/homebrew.nix` | Homebrew formulas, casks, and activation policy |
| `modules/macos.nix` | macOS defaults, fonts, and Zsh |
| `modules/nix-homebrew.nix` | Homebrew installation managed by nix-homebrew |

Copy these files into the `nix/` directory of the dotfiles repository, retain
the existing `flake.lock`, and apply with:

```sh
darwin-rebuild switch --flake .#omg-mac
```

The current update policy was intentionally preserved: a rebuild updates
Homebrew and the Mac App Store. If you want predictable rebuilds, change
`modules/homebrew.nix` to `autoUpdate = false`, `upgrade = false`, and use
explicit update commands instead.
