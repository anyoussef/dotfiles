{
  description = "ayous macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    ...
  }: {
    darwinConfigurations.fartbox = darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      modules = [
        # System config
        {
          nixpkgs.hostPlatform = "aarch64-darwin";

          system.primaryUser = "ayous";

          nix.enable = true;
          nixpkgs.config.allowUnfree = true;

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          programs.zsh.enable = true;

          environment.shells = with nixpkgs.legacyPackages.aarch64-darwin; [
            bash
            zsh
          ];

          environment.systemPackages = with nixpkgs.legacyPackages.aarch64-darwin; [
            coreutils
          ];

          fonts.packages = with nixpkgs.legacyPackages.aarch64-darwin; [
            nerd-fonts.jetbrains-mono
          ];

          users.users.ayous = {
            home = "/Users/ayous";
          };

          ids.gids.nixbld = 350;

          system = {
            stateVersion = 4;

            defaults = {
              dock = {
                autohide = true;
                show-recents = false;
                persistent-apps = [
                  "/System/Applications/Messages.app"
                  "/Applications/Nix Apps/Firefox Developer Edition.app"

                  # Nix-installed apps
                  "/System/Applications/Mail.app"
                  "/Applications/Nix Apps/iTerm2.app"
                  "/System/Applications/System Settings.app"
                ];
              };
            };
          };
        }

        home-manager.darwinModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.ayous = {pkgs, ...}: {
              home.username = "ayous";
              home.homeDirectory = "/Users/ayous";
              home.stateVersion = "22.11";

              home.packages = [
                pkgs.raycast
                pkgs.iterm2
                pkgs.firefox-devedition
                pkgs.oh-my-zsh

                # Lazyvim
                pkgs.fzf
                pkgs.lua
                pkgs.curl
                pkgs.neovim
                pkgs.tree-sitter
                pkgs.git
                pkgs.ripgrep
              ];

              home.sessionPath = [
                "/etc/profiles/per-user/ayous/bin"
                "/run/current-system/sw/bin"
              ];

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
