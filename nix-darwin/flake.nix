{
  description = "youssef nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew section
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Declarative tap management
    homebrew-core = {
	url = "github:homebrew/homebrew-core";
	flake = false;
    };
    homebrew-cask = {
	url = "github:homebrew/homebrew-cask";
	flake = false;
    };
    
    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-cask, home-manager, ... }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      system.primaryUser = "ayous";

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages =
        [ 
	pkgs.git
	pkgs.vim
	pkgs.neovim
	pkgs.mkalias
	pkgs.tmux
	pkgs.iterm2
	pkgs.obsidian
	pkgs.raycast
	pkgs.firefox-devedition
	pkgs.hidden-bar

	# Lazy Vim Shyat
	pkgs.curl
	pkgs.fd
	pkgs.ripgrep
	pkgs.tree-sitter
	pkgs.fzf
        ];

      fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	];

	system.activationScripts.applications.text = let
	  env = pkgs.buildEnv {
	    name = "system-applications";
	    paths = config.environment.systemPackages;
	    pathsToLink = ["/Applications"];
	  };
	in
	  pkgs.lib.mkForce ''
	  # Set up applications.
	  echo "setting up /Applications..." >&2
	  rm -rf /Applications/Nix\ Apps
	  mkdir -p /Applications/Nix\ Apps
	  find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
	  while read -r src; do
	    app_name=$(basename "$src")
	    echo "copying $src" >&2
	    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
	  done
	      '';
	
	/*nix-homebrew.darwinModules.nix-homebrew = {
		enable = true;
		enableRosetta = true;
		user = "ayous";
		packages = [];
		casks = ["minecraft"];
		taps = [];
	};*/

	system.defaults = {
		dock = {
			autohide = true;
			show-recents = false;
		};
		NSGlobalDomain = {
			NSAutomaticCapitalizationEnabled = false;
			NSAutomaticSpellingCorrectionEnabled = false;
		};
	};

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
     
      users.users.ayous = {
	home = "/Users/ayous";
	shell = pkgs.zsh;
      };
	
      environment.shells = [ pkgs.zsh ];

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#fartbox
    darwinConfigurations."fartbox" = nix-darwin.lib.darwinSystem {
      modules = [ 
		configuration
		nix-homebrew.darwinModules.nix-homebrew {
			nix-homebrew = {
				enable = true;
				enableRosetta = true;
				user = "ayous";
				};
			}
		home-manager.darwinModules.home-manager {
			home-manager.users.ayous = { pkgs, ...}: {
				home.stateVersion = "24.11";
				programs.zsh = {
					enable = true;
					oh-my-zsh = {
						enable = true;
						theme = "robbyrussell";
						plugins = [ "git" ];
					};
				};
			};
		}
	 ];
    };
  };
}
