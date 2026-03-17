{
  config,
  lib,
  pkgs,
  jj-starship,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  # Add COSMIC desktop
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Exclude broken packages
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
  ];

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # anon
  users.users.anon = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    brave
    hunspell
    hunspellDicts.en-ca-large
    libreoffice
    nix-output-monitor
    obsidian
    signal-desktop
    wl-clipboard
  ];

  nixpkgs.config.allowUnfree = true;

  ### programs ###

  programs.firefox.enable = true;

  programs.zsh.enable = true;

  programs.nix-ld.enable = true;

  ### services ###

  services.flatpak.enable = true;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-7d";
  };
}
