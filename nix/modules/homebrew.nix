{ ... }:

{
  homebrew = {
    enable = true;

    # Preserved from the existing configuration.
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    brews = [
      "lxc"
      "pnpm"
      "syncthing"
    ];

    greedyCasks = false;

    casks = [
      "alt-tab"
      "android-platform-tools"
      "android-studio"
      "appcleaner"
      "balenaetcher"
      "brave-browser"
      "chatgpt"
      "cheatsheet"
      "discord"
      "firefox"
      "font-fontawesome"
      "foobar2000"
      "ghostty"
      "iina"
      "imageoptim"
      "jordanbaird-ice"
      "localsend"
      "lulu"
      "macshot"
      "obsidian"
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
      "zed"
    ];

    taps = [ "homebrew/bundle" ];
  };
}
