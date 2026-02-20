{
  description = "ayous macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Declarative Homebrew taps
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  }: let
    system = "aarch64-darwin";
  in {
    darwinConfigurations.fartbox = darwin.lib.darwinSystem {
      inherit system;

      modules = [
        # ----------------------------
        # nix-homebrew
        # ----------------------------
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "ayous";

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            mutableTaps = false;
          };
        }

        # ----------------------------
        # System Configuration
        # ----------------------------
        {
          nixpkgs.hostPlatform = system;
          nixpkgs.config.allowUnfree = true;

          system.primaryUser = "ayous";
          system.stateVersion = 4;

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          programs.zsh.enable = true;

          environment.shells = with nixpkgs.legacyPackages.${system}; [
            bash
            zsh
          ];

          environment.systemPackages = with nixpkgs.legacyPackages.${system}; [
            coreutils
          ];

          fonts.packages = with nixpkgs.legacyPackages.${system}; [
            nerd-fonts.jetbrains-mono
          ];

          users.users.ayous = {
            home = "/Users/ayous";
          };

          ids.gids.nixbld = 350;

          system.defaults.dock = {
            autohide = true;
            show-recents = false;
            persistent-apps = [
              "/System/Applications/Messages.app"
              "/System/Applications/Mail.app"
              "/System/Applications/System Settings.app"
              "/Applications/Nix Apps/Firefox Developer Edition.app"
              "/Applications/Nix Apps/iTerm2.app"
            ];
          };
        }

        # ----------------------------
        # Home Manager
        # ----------------------------
        home-manager.darwinModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.ayous = {pkgs, ...}: {
              home.username = "ayous";
              home.homeDirectory = "/Users/ayous";
              home.stateVersion = "22.11";

              # ------------------------
              # Packages
              # ------------------------
              home.packages = with pkgs; [
                # Apps
                raycast
                iterm2
                firefox-devedition
                spotify

                # CLI
                git
                neovim
                ripgrep
                fzf
                lua
                curl
                tree-sitter
              ];

              home.sessionPath = [
                "$HOME/.nix-profile/bin"
                "/run/current-system/sw/bin"
              ];

              # ------------------------
              # Zsh
              # ------------------------
              programs.zsh = {
                enable = true;

                oh-my-zsh = {
                  enable = true;
                  theme = "gozilla";
                  plugins = ["git"];
                };
              };
            };
          };
        }
      ];
    };
  };
}
