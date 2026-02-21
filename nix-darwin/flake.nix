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

  outputs =
    { self
    , nixpkgs
    , darwin
    , home-manager
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , ...
    }:
    let
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations.fartbox = darwin.lib.darwinSystem {
        inherit system;

        modules = [
          # ----------------------------
          # nix-homebrew (installs brew itself)
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

            environment.systemPackages = with nixpkgs.legacyPackages.${system}; [
              coreutils
            ];

            fonts.packages = with nixpkgs.legacyPackages.${system}; [
              nerd-fonts.jetbrains-mono
            ];

            users.users.ayous.home = "/Users/ayous";
            ids.gids.nixbld = 350;

            # ----------------------------
            # Declarative Homebrew
            # ----------------------------
            homebrew = {
              enable = true;

              onActivation = {
                autoUpdate = false;
                upgrade = false;
                cleanup = "uninstall";
              };

              taps = [
                "homebrew/homebrew-core"
                "homebrew/homebrew-cask"
              ];

              brews = [
              ];

              casks = [
                "visual-studio-code"
                "discord"
                "anaconda"
                "onedrive"
                "microsoft-outlook"
                "blender"
                "minecraft"
              ];
            };

            # ----------------------------
            # macOS Defaults
            # ----------------------------
            system.defaults.dock = {
              autohide = true;
              show-recents = false;
              persistent-apps = [
                "/Users/ayous/Applications/Home Manager Apps/Firefox Developer Edition.app"
                "/System/Applications/Messages.app"
                "/Users/ayous/Applications/Home Manager Apps/Obsidian.app"
                "/Applications/Discord.app"
                "/Applications/Blender.app"
                "/Applications/Visual Studio Code.app"
                "/System/Applications/Mail.app"
                "/Applications/Microsoft Outlook.app"
                "/System/Applications/Calendar.app"
                "/Applications/Minecraft.app"
                "/Users/ayous/Applications/Home Manager Apps/Iterm2.app"
                "/System/Applications/System Settings.app"
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

              users.ayous = { pkgs, ... }: {
                home.username = "ayous";
                home.homeDirectory = "/Users/ayous";
                home.stateVersion = "22.11";

                home.packages = with pkgs; [
                  git
                  cargo
                  fd
                  scala_2_13
                  neovim
                  ripgrep
                  fzf
                  lua
                  wget
                  luarocks
                  curl
                  tree-sitter
                  spotify
                  firefox-devedition
                  raycast
                  iterm2
                  obsidian
                  lazygit
                ];

                programs.zsh = {
                  enable = true;

                  oh-my-zsh = {
                    enable = true;
                    theme = "gozilla";
                    plugins = [ "git" ];
                  };
                };
              };
            };
          }
        ];
      };
    };
}
