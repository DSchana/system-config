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
    krita
    kicad
    lmstudio
    vulkan-tools
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  ### Locally hosted services ###

  services.flatpak.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
      OLLAMA_KEEP_ALIVE = "-1";
    };
  };

  services.open-webui = {
    enable = true;
    port = 9999;
  };

  system.stateVersion = "25.11";
}
