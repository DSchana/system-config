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

  # dschana
  users.users.dschana = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    brave
    ghostty
    grayjay
    hunspell
    hunspellDicts.en-ca-large
    jj-starship
    libreoffice
    obsidian
    qbittorrent
    signal-desktop
    syncthing
    tailscale
    wl-clipboard
  ];

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  ### programs ###

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "dschana" ];
  };

  programs.firefox.enable = true;

  programs.zsh.enable = true;

  programs.nix-ld.enable = true;

  ### services ###

  services.tailscale.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-7d";
  };
}
