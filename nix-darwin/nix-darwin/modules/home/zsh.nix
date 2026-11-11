{
  programs.zsh = {
    enable = true;

    shellAliases = {
      l = "ls -alh";
      ll = "ls -l";
      ls = "ls --color=tty";

      # CS476
      scalaenv = "nix develop --impure --expr 'with import <nixpkgs> {}; mkShell { packages = [ jdk17 coursier jupyter ]; shellHook = \"export SCALA_VERSION=2.13\"; }'";

      # Manual Fallback
      nixgc = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d";

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

      # SSH Destinations
      ssh-mc = "s";
    };

    oh-my-zsh = {
      enable = true;
      theme = "gozilla";
      plugins = [ "git" ];
    };
  };
}
