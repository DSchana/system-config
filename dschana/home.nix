{ config, pkgs, ... }:

{
  home.username = "dschana";
  home.homeDirectory = "/home/dschana";

  home.stateVersion = "25.11";

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./zshrc
  };

  programs.home-manager.enable = true;
}