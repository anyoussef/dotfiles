# Baseline system packages, fonts, shell
{ pkgs, ... }: {
  documentation.enable = false;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    coreutils
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
