{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "dschana";

  users.users.dschana = {
    name = "dschana";
    home = "/Users/dschana";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    casks = [
      "1password"
      "bartender"
      "brave-browser"
      "docker"
      "karabiner-elements"
      "linear-linear"
      "lunar"
      "obsidian"
      "proton-mail"
      "rectangle"
      "signal"
      "slack"
      "vlc"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.dschana = import ./home.nix;
  };

  system.stateVersion = 5;
}
