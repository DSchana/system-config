{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  home-manager.users.dschana = import ./home.nix;

  services.tlp.settings = {
    CPU_SCALING_MAX_FREQ_ON_AC = 3300000;
    CPU_SCALING_MAX_FREQ_ON_BAT = 1500000;
    DISK_DEVICES = "sda";
    DISK_APM_LEVEL_ON_AC = "254";
    DISK_APM_LEVEL_ON_BAT = "128";
  };

  system.stateVersion = "25.11";
}
