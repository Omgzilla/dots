{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # CLI
    fd
    fzf
    htop
    jdk17
    juju
    neovim
    nixd
    nixfmt
    nodejs_22
    python313
    python313Packages.pip
    ripgrep
    statix
    stow
    tmux
    tree-sitter
    zsh-completions
    zoxide

    (writeShellScriptBin "nix-upgrade" ''
      set -euo pipefail

      FLAKE="$HOME/.dotfiles/nix#omg-mac"

      echo "Applying nix-darwin system config..."
      sudo darwin-rebuild switch --flake "$FLAKE"
    '')
  ];
}
