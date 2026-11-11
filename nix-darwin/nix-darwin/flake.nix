{
  description = "ayous macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ darwin, ... }:
    let
      hostPlatform = "aarch64-darwin";
      username = "ayous";
    in
    {
      darwinConfigurations.fartbox = darwin.lib.darwinSystem {
        system = hostPlatform;
        specialArgs = { inherit inputs hostPlatform username; };
        modules = [ ./hosts/fartbox ];
      };
    };
}
