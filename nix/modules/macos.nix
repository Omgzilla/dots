{ pkgs, ... }:

{
  fonts.packages = [ pkgs.nerd-fonts.ubuntu-mono ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.05;
      persistent-apps = [
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
    };

    loginwindow.GuestEnabled = false;

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      KeyRepeat = 2;
    };
  };
}
