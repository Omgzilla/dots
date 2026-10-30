{ ... }:

{
  homebrew = {
    enable = true;

    # Rebuilds apply the declared app list; nix-upgrade handles updates.
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };

    brews = [
      "incus"
      "lxc"
      "pnpm"
    ];

    greedyCasks = false;

    casks = [
      "alt-tab"
      "appcleaner"
      "balenaetcher"
      "brave-browser"
      "chatgpt"
      "cheatsheet"
      "firefox"
      "font-fontawesome"
      "foobar2000"
      "ghostty"
      "iina"
      "imageoptim"
      "jordanbaird-ice"
      "localsend"
      "lulu"
      "macpacker"
      "macshot"
      "obsidian"
      "pika"
      "qbittorrent"
      "signal"
      "slack"
      "spotify"
      "steam"
      "teamviewer"
      "transmit"
      "vesktop"
      "zed"
    ];

    taps = [ "homebrew/bundle" ];
  };
}
