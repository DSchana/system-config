{ config, pkgs, ... }:

{
  home.username = "dschana";
  home.homeDirectory = "/home/dschana";

  home.stateVersion = "25.11";

  home.file = {
    ".oh-my-zsh".source = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
    ".zshrc".source = ./zshrc;
    ".tmux.conf".source = ./tmux.conf;
    ".config" = {
      source = ./config;
      recursive = true;
    };
  };

  programs.home-manager.enable = true;
}