# Everything specific to this machine, plus the list of modules it uses.
{ pkgs, hostPlatform, username, ... }: {
  imports = [
    ../../modules/darwin/nix.nix
    ../../modules/darwin/base.nix
    ../../modules/darwin/defaults.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/gc.nix
  ];

  nixpkgs.hostPlatform = hostPlatform;

  system.primaryUser = username;
  system.stateVersion = 4;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
}
