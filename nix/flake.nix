{
  description = "Nix Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    #nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.alacritty
          pkgs.fd
          pkgs.fzf
          pkgs.htop
          pkgs.hugo
          pkgs.juju
          pkgs.mkalias
          pkgs.neovim
          pkgs.nodejs_22
          pkgs.obsidian
          pkgs.python311
          pkgs.python311Packages.pip
          pkgs.stow
          pkgs.zoxide
        ];

      # Fonts packages
      fonts.packages = [
        pkgs.nerd-fonts.ubuntu-mono
      ];
      
      # Homebrew applications
      homebrew = {
        enable = true;
        brews = [
          "lxc"
          "mas"
        ];
        casks = [
          "alt-tab"
          "android-platform-tools"
          "brave-browser"
          "cheatsheet"
          "discord"
          "firefox"
          "font-fontawesome"
          "ghostty"
          "iina"
          "imageoptim"
          "iterm2"
          "lulu"
          "onyx"
          "pika"
          "qbittorrent"
          "spotify"
          "steam"
          "the-unarchiver"
          "transmit"
          "wine-stable"
        ];
        masApps = {
          "Bitwarden" = 1352778147;
          "Tailscale" = 1475387142;
        };
        taps = [
          "homebrew/bundle"
        ];
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      # Auto upgrade nix package and the daemon service.
      #services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Activation Script for MacOS applications
      # https://gist.github.com/elliottminns/211ef645ebd484eb9a5228570bb60ec3
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      # MacOS preferences
      system.defaults = {
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
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
        NSGlobalDomain.KeyRepeat = 2;
      };
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

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
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."simple".pkgs;
  };
}
