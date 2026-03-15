{ config, pkgs, ... }:

{
  imports = [ ../../shared/home.nix ];

  programs.ssh.matchBlocks = {
    "home-server.dschana.tailscale" = {
      hostname = "100.124.96.21";
      user = "dschana";
    };
    "home-server.dschana.local" = {
      hostname = "192.168.2.12";
      user = "dschana";
    };
  };
}
