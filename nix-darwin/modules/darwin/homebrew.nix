# nix-homebrew (installs brew itself, taps pinned by flake.lock) + declarative brews/casks
{ inputs, username, ... }: {
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };

    mutableTaps = false;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
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
      "iterm2"
      "displaylink"
      "google-chrome"
      "spotify"
      "runelite"
      "discord"
      "raycast"
      "obsidian"
      "onedrive"
      "intellij-idea"
      "tailscale-app"
      "docker-desktop"
      "blender"
      "zoom"
      "obs"
      "microsoft-word"
      "microsoft-outlook"
      "microsoft-powerpoint"
      "visual-studio-code"
      "firefox@developer-edition"
      "firefox"
      "claude"
    ];
  };
}
