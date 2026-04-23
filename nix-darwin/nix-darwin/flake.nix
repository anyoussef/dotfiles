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


            users.users.ayous = {
              home = "/Users/ayous";
              shell = nixpkgs.legacyPackages.${system}.zsh;
            };

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
                "qemu"
                "x86_64-elf-gcc"
                "nasm"
              ];

              casks = [
                "visual-studio-code"
                "steam"
                "discord"
                "onedrive"
                "microsoft-outlook"
                "blender"
                "minecraft"
                "tailscale-app"
                "docker-desktop"
                "wireshark-chmodbpf"
                "zoom"
                "obs"
                "curseforge"
                "microsoft-word"
                "microsoft-powerpoint"
                "firefox@developer-edition"
              ];
            };

            # ----------------------------
            # macOS Defaults
            # ----------------------------
            system.defaults.dock = {
              autohide = true;
              show-recents = false;
              persistent-apps = [
                "/Applications/Firefox Developer Edition.app"
                "/System/Applications/Messages.app"
                "/Users/ayous/Applications/Home Manager Apps/Obsidian.app"
                "/Applications/Discord.app"
                "/Applications/Blender.app"
                "/Applications/Visual Studio Code.app"
                "/System/Applications/Mail.app"
                "/Applications/Microsoft Outlook.app"
                "/System/Applications/Calendar.app"
                "/Users/ayous/Applications/Home Manager Apps/Spotify.app"
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
                  python314
                  git
                  cargo
                  fd
                  neovim
                  maven
                  pkgs.jdk8
                  hidden-bar
                  jetbrains.idea
                  jetbrains.rider
                  ripgrep
                  fzf
                  lua
                  wget
                  luarocks
                  curl
                  tree-sitter
                  spotify
                  raycast
                  iterm2
                  obsidian
                  lazygit
                  tmux
                  docker
                  inetutils
                  SDL2
                  nodejs_24
                ];

                programs.zsh = {
                  enable = true;

                  shellAliases =
                    {
                      l = "ls -alh";
                      ll = "ls -l";
                      ls = "ls --color=tty";

                      # CS476
                      scalaenv = "nix develop --impure --expr 'with import <nixpkgs> {}; mkShell { packages = [ jdk17 coursier jupyter ]; shellHook = \"export SCALA_VERSION=2.13\"; }'";

                      # Python
                      pipenvi = "python3 -m venv .venv";
                      pipenv = "source .venv/bin/activate";

                      # General Flakes
                      nixflake = "wget https://github.com/anyoussef/dotfiles/raw/refs/heads/master/flake.nix && nvim";

                      # Nix
                      nixre = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin#fartbox";
                      nixup = "nix flake update --flake ~/.config/nix-darwin/";
                      nixpush = ''
                        cp -r /Users/ayous/.config/nix-darwin /Users/ayous/dotfiles/nix-darwin &&
                        cd ~/dotfiles &&
                        git add nix-darwin &&
                        if ! git diff-index --quiet HEAD --; then
                          git commit -m "update nix-darwin"
                          git push
                        else
                          echo "No changes to commit"
                        fi
                      '';
                    };

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


