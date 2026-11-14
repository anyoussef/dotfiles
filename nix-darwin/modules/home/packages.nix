{ pkgs, ... }: {
  home.packages = with pkgs; [
    cargo
    claude-code
    curl
    docker
    fd
    fzf
    git
    inetutils
    jdk8
    lazygit
    lua
    luarocks
    maven
    neovim
    nodejs_24
    python314
    ripgrep
    rustc
    SDL2
    tmux
    tree-sitter
    uv
    wget
    wimlib
  ];
}
