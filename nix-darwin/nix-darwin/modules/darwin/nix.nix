# Nix daemon / nixpkgs settings
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  ids.gids.nixbld = 350;
}
