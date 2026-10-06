{ config, pkgs, ... }:

let
  # Use the same app list and per-app options as nix-darwin activation.
  upgradeBrewfile = pkgs.writeText "nix-upgrade-Brewfile" config.homebrew.brewfile;
  brew = "${config.homebrew.prefix}/bin/brew";
in
{
  environment.systemPackages = with pkgs; [
    # CLI
    fd
    fzf
    herdr
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

    (writeShellScriptBin "nix-rebuild" ''
      set -euo pipefail

      flake_dir="$HOME/.local/dots/nix"
      flake_ref="$flake_dir#omg-mac"

      echo "Building the locked nix-darwin configuration..."
      darwin-rebuild build --flake "$flake_ref"

      echo "Applying the configuration..."
      sudo darwin-rebuild switch --flake "$flake_ref"
    '')

    (writeShellScriptBin "nix-upgrade" ''
      set -euo pipefail

      flake_dir="$HOME/.local/dots/nix"
      flake_ref="$flake_dir#omg-mac"

      cd "$flake_dir"

      echo "Updating Nixpkgs and nix-darwin..."
      nix flake update nixpkgs nix-darwin

      echo "Changed locked inputs:"
      git diff -- flake.lock

      echo "Building the upgraded configuration..."
      darwin-rebuild build --flake "$flake_ref"

      echo "Applying the upgraded configuration..."
      sudo darwin-rebuild switch --flake "$flake_ref"

      # Run Homebrew as the logged-in user, never through sudo.
      echo "Updating Homebrew..."
      "${brew}" update

      echo "Upgrading declared Homebrew packages and apps..."
      HOMEBREW_NO_AUTO_UPDATE=1 "${brew}" bundle --file="${upgradeBrewfile}"

      echo "Updating Mac App Store apps..."
      mas upgrade

      echo "Upgrade complete. Review and commit flake.lock if everything works."
    '')
  ];
}
