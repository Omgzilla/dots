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
nix flake update --flake ~/dots/nix/
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
