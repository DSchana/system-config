{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  home-manager.users.dschana = import ./home.nix;

  system.stateVersion = "25.11";
}
