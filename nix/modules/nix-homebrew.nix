{ ... }:

{
  nix-homebrew = {
    enable = true;

    # Apple Silicon only: maintain an x86_64 Homebrew installation too.
    enableRosetta = true;

    user = "marcus";

    # Keep while adopting nix-homebrew; disable after migration is complete.
    autoMigrate = true;
  };
}
