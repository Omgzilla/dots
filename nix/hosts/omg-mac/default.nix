{ self, ... }:

{
  imports = [
    ../../modules/packages.nix
    ../../modules/homebrew.nix
    ../../modules/mas.nix
    ../../modules/macos.nix
    ../../modules/nix-homebrew.nix
  ];

  # Determinate Nix owns the Nix daemon and nix.conf.
  nix.enable = false;

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

  system = {
    primaryUser = "marcus";
    configurationRevision = self.rev or self.dirtyRev or null;

    # Keep this at the version from the initial nix-darwin installation.
    stateVersion = 6;
  };
}
