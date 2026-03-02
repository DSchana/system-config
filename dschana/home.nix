{ config, pkgs, ... }:

{
  home.username = "dschana";
  home.homeDirectory = "/home/dschana";

  home.stateVersion = "25.11";

  home.file = {
    ".oh-my-zsh".source = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
    ".zshrc".source = ./zshrc;
    ".config/starship.toml".source = ./starship.toml;
  };

  programs.home-manager.enable = true;
}