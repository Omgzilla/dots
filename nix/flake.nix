{
  description = "Nix Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    #nix-darwin.url = "github:LnL7/nix-darwin";
    #nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = { self, nix-darwin, nixpkgs, nix-homebrew, mac-app-util }:
  let
    configuration = { pkgs, ... }: {
      # Determinate manages Nix; tell nix-darwin not to.
      nix.enable = false;
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      # Search pkgs here https://search.nixos.org/packages
      environment.systemPackages = with pkgs; [ 
          # CLI
          fd
          fzf
          htop
          #hugo
          juju
          neovim
          nixd
          nixfmt
          nodejs_22
          obsidian
          python313
          python313Packages.pip
          ripgrep
          statix
          stow
          tree-sitter
          #vscode
          #windsurf
          zsh-completions
          zoxide

          (writeShellScriptBin "nix-upgrade" ''
            set -euo pipefail
          
            FLAKE="$HOME/.dotfiles/nix#omg-mac"
          
            echo "Applying nix-darwin system config..."
            sudo darwin-rebuild switch --flake "$FLAKE"
          
            echo "Checking Mac App Store apps..."
          
            declare -A MAS_APPS=(
              ["937984704"]="Amphetamine"
              ["1352778147"]="Bitwarden"
              ["1475387142"]="Tailscale"
            )
          
            installed_ids="$(mas list | awk '{print $1}')"
          
            for id in "''${!MAS_APPS[@]}"; do
              name="''${MAS_APPS[$id]}"
          
              if echo "$installed_ids" | grep -qx "$id"; then
                echo "Already installed: $name"
              else
                echo "Installing missing MAS app: $name ($id)"
                mas install "$id"
              fi
            done
          
            echo "Updating installed Mac App Store apps..."
          
            if mas outdated | grep -q .; then
              mas upgrade
            else
              echo "No Mac App Store updates available."
            fi
          '')
        ];

      # Fonts packages
      fonts.packages = [
        pkgs.nerd-fonts.ubuntu-mono
      ];
      
      # Homebrew applications
      # Search pkgs here https://brew.sh/
      homebrew = {
        enable = true;
        
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };

        brews = [
          "lxc"
          "mas"
          "openjdk@17"
          "syncthing"
          "tmux"
        ];
        greedyCasks = true;
        casks = [
          "alt-tab"
          "android-platform-tools"
          "android-studio"
          "appcleaner"
          "balenaetcher"
          "brave-browser"
          "chatgpt"
          "cheatsheet"
          #"discord"
          "firefox"
          "font-fontawesome"
          "foobar2000"
          "ghostty"
          "iina"
          "imageoptim"
          #"iterm2"
          "jordanbaird-ice"
          "localsend"
          "lulu"
          "macshot"
          "onyx"
          "pika"
          "qbittorrent"
          "signal"
          "slack"
          "spotify"
          "steam"
          "teamviewer"
          "the-unarchiver"
          "transmit"
          "vesktop"
          #"wezterm"
          "windsurf"
        ];
        #masApps = {
        #  "Amphetamine" = 937984704;
        #  "Bitwarden" = 1352778147;
        #  "Tailscale" = 1475387142;
        #};
        taps = [
          "homebrew/bundle"
        ];
      };

      # Auto upgrade nix package and the daemon service.
      #services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      # Determinate Nix manages nix.conf; this is intentionally not configured here.
      # nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina

      # Activation Script for MacOS applications
      # https://gist.github.com/elliottminns/211ef645ebd484eb9a5228570bb60ec3
      #system.activationScripts.applications.text = let
      #  env = pkgs.buildEnv {
      #    name = "system-applications";
      #    paths = config.environment.systemPackages;
      #    pathsToLink = "/Applications";
      #  };
      #in
      #  pkgs.lib.mkForce ''
      #  # Set up applications.
      #  echo "setting up /Applications..." >&2
      #  rm -rf /Applications/Nix\ Apps
      #  mkdir -p /Applications/Nix\ Apps
      #  find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      #  while read -r src; do
      #    app_name=$(basename "$src")
      #    echo "copying $src" >&2
      #    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      #  done
      #      '';

      # MacOS preferences
      system = {
        defaults = {
          dock.autohide = true;
          dock.autohide-delay = 0.05;
          dock.persistent-apps = [
            "/Applications/Firefox.app"
            "/Applications/Brave Browser.app"
            "/System/Applications/Messages.app"
            "/System/Applications/FaceTime.app"
            "/System/Applications/Mail.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Notes.app"
            "/System/Applications/System Settings.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
          ];
          loginwindow.GuestEnabled = false;
          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleInterfaceStyleSwitchesAutomatically = true;
            KeyRepeat = 2;
            };
        };
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;

        primaryUser = "marcus";
        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        stateVersion = 6;

      };
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."omg-mac" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # Apple Silicon Only
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "marcus";
            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
        mac-app-util.darwinModules.default
      ];
    };

    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."omg-mac".pkgs;
  };
}
