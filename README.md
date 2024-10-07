# This is my configuration files.
## Clone and run with stow
```bash
git clone https://github.com/Omgzilla/dots.git && cd /dots && stow -t ~/ .
```

*This require [GNU Stow](https://www.gnu.org/software/stow/) to be installed*
# Debian/Ubuntu
```bash
sudo apt install stow
```
# Homebrew on MacOS
```zsh
brew install stow
```

## Install Nix-darwin on MacOS using flake
*Follow [this](https://www.youtube.com/watch?v=Z8BL8mdzWHI) guide for new setup*
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
darwin-rebuild switch --flake ~/dots/nix#omg-mac
```
