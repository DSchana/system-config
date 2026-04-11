# system-config
Quick bring-up and sync between machines and environments

## NixOS (full system)
First time on a fresh NixOS install:
```
sudo nix --extra-experimental-features "nix-command flakes" run nixpkgs#nixos-rebuild -- switch --flake github:dschana/system-config#<machine>
```

Subsequent rebuilds:
```
sudo nixos-rebuild switch --flake github:dschana/system-config#<machine>
```

Available machines: `dschana-laptop`, `dschana-desktop`

## nix-darwin (macOS system)
Install [Nix](https://install.determinate.systems/nix) and [Homebrew](https://brew.sh) first.

First time bootstrap:
```
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake github:dschana/system-config#anz-macbook
```

Subsequent rebuilds:
```
darwin-rebuild switch --flake github:dschana/system-config#anz-macbook --refresh
```

## Home Manager (standalone, any OS)
For non-NixOS machines where you just want the shell, tools, and configs:
```
nix run home-manager -- switch --flake github:dschana/system-config#<config>
```

Generic (shared config only): `x86-linux`, `arm-linux`, `x86-darwin`, `arm-darwin`

## Adding a new NixOS machine
1. Install NixOS from the ISO
2. Copy `/etc/nixos/hardware-configuration.nix` to `machines/<name>/hardware-configuration.nix`
3. Create `machines/<name>/configuration.nix` and `machines/<name>/home.nix`
4. Add entry to `flake.nix` under `nixosConfigurations`
5. Rebuild
