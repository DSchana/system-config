{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "dschana-desktop";

  home-manager.users.dschana = import ./home.nix;

  system.stateVersion = "25.11";
}
