# This is my configuration files.

## Clone and run with stow

```bash
git clone https://github.com/Omgzilla/dots.git && cd /dots && stow -t ~/ .
```

# Install stow

_This require [GNU Stow](https://www.gnu.org/software/stow/) to be installed_

## Arch

```bash
sudo pacman -S stow
```

## Debian/Ubuntu

```bash
sudo apt install stow
```

## Homebrew on MacOS

```zsh
brew install stow
```

# Nix on MacOS

## Install Nix-darwin on MacOS using flake

_Follow [this](https://www.youtube.com/watch?v=Z8BL8mdzWHI) guide for new setup_

### Install Nix package manager

*https://nixos.org/download/*

```zsh
sh <(curl -L https://nixos.org/nix/install)`
```
Use determinate nix if above doesn't work (like on Sonoma)
```zsh
curl -L https://install.determinate.systems/nix | sh -s -- install
```
*Repair/reinstall using determinate*
```zsh
curl -L https://install.determinate.systems/nix | sh -s -- install --diagnose --reinstall
```

### Switch to this flake

```zsh
nix run nix-darwin -- switch --flake ~/dots/nix#omg-mac
```

### Rebuild from flake

```zsh
sudo darwin-rebuild switch --flake ~/dots/nix#omg-mac
```

### Update flake

```zsh
# 1) Update inputs (with user, not with sudo)
cd ~/.dotfiles/nix
nix flake update --flake  # update all inputs to latest
# or only nixpkgs
# nix flake lock --update-input nixpks

# 2) Commit the new lockfile
git add flake.lock
git commit -m "nix-flake: update inputs"

# 3) Rebuild/apply
sudo darwin-rebuild switch --flake .#omg-mac --no-write-lock-file
```

#### Verify what your're pinned to

```bash
nix flake metadata ~/.dotfiles/nix   # shows locked commits for nixpkgs, nix-darwin, etc.
darwin-rebuild list-generations      # confirms a new system generation was created
```

### Docs for nix-darwin

```zsh
darwin-help
```

### Upgrade failed?

Try remove `flake.lock` and re-build a new one

```zsh
rm flake.lock
nix flake lock
```
