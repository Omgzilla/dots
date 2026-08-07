{
  description = "Nix Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nix-darwin = {
    #  url = "github:nix-darwin/nix-darwin";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      mac-app-util,
      ...
    }:
    {
      darwinConfigurations."omg-mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };

        modules = [
          ./hosts/omg-mac
          nix-homebrew.darwinModules.nix-homebrew
          mac-app-util.darwinModules.default
        ];
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;

      darwinPackages = self.darwinConfigurations."omg-mac".pkgs;
    };
}
