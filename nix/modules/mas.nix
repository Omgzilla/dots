{ ... }:

{
  # Native nix-darwin management for Mac App Store applications.
  # This installs `mas` from Nix, rather than through Homebrew.
  programs.mas = {
    enable = true;

    packages = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Tailscale" = 1475387142;
    };

    # Keep system rebuilds predictable. Run `mas upgrade` when you want updates.
    update = false;

    # Do not remove Store apps that are not declared above.
    cleanup = false;
  };
}
