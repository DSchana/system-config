{ config, pkgs, ... }:

{
  home.username = "anon";
  home.homeDirectory = "/home/anon";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    (btop.override { cudaSupport = true; })
  ];

  programs.home-manager.enable = true;
}
