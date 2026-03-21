{ config, pkgs, ... }:

{
  imports = [ ../../dev-shared/home.nix ];

  xdg.userDirs = {
    enable = true;
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
  };

  xdg.configFile."autostart/1password.desktop".text = ''
    [Desktop Entry]
    Name=1Password
    Exec=1password --silent
    Terminal=false
    Type=Application
  '';

  programs.ssh.matchBlocks = {
    "home-server.dschana.tailscale" = {
      hostname = "100.124.96.21";
      user = "dschana";
    };
    "home-server.dschana.local" = {
      hostname = "192.168.2.12";
      user = "dschana";
    };
  };
}
