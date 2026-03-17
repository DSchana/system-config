{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
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
