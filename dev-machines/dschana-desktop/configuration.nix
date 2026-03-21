{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/12adbf25-57dc-4572-99ff-41705534156a";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
  };

  networking.hostName = "dschana-desktop";

  home-manager.users.dschana = import ./home.nix;

  environment.systemPackages = with pkgs; [
    davinci-resolve
    freecad
    kicad
  ];

  system.stateVersion = "25.11";
}
