{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "dschana";

  users.users.dschana = {
    name = "dschana";
    home = "/Users/dschana";
    shell = pkgs.zsh;
  };

  nix.enable = false; # Using determinate nix

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

  environment.systemPackages = with pkgs; [
    jj-starship
  ];

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
      "ghostty"
      "karabiner-elements"
      "linear-linear"
      "lunar"
      "obsidian"
      "proton-mail"
      "rectangle"
      "signal"
      "slack"
      "vlc"
      "vscodium"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.dschana = import ./home.nix;
    backupFileExtension = "backup";
  };

  launchd.user.agents.searxng = {
    command = "/usr/local/bin/docker run --rm --name searxng -p 8888:8080 -e SEARXNG_SECRET=qZu8NVpp6o!4TTnV8kEc-this-is-local-only searxng/searxng";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      ThrottleInterval = 30;
      EnvironmentVariables = {
        PATH = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };

  system.stateVersion = 5;
}
