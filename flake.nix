{
  description = "NixOS Configuration";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # Use the same nixpkgs
    };

    jj-starship = {
      url = "github:dmmulroy/jj-starship";
      inputs.nixpkgs.follows = "nixpkgs";  # Use the same nixpkgs
    };
  };

  outputs = { self, determinate, nixpkgs, home-manager, jj-starship, ... }@inputs:
  let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = f: builtins.listToAttrs (
      map (name: { inherit name; value = f name; }) systems
    );

    mkNixos = { host, system }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        jj-starship = jj-starship.packages.${system}.default;
      };
      modules = [
        determinate.nixosModules.default
        home-manager.nixosModules.home-manager
        ./shared/configuration.nix
        ./machines/${host}/configuration.nix
      ];
    };

    mkHome = system: modules: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./shared/home.nix ] ++ modules;
    };
  in {
    nixosConfigurations = {
      dschana-laptop = mkNixos {
        host = "dschana-laptop";
        system = "x86_64-linux";
      };
    };

    homeConfigurations = {
      # machine-specific (hame a hom.nix with overrides)
      "dschana-laptop" = mkHome "x86_64-linux" [ ./machines/dschana-laptop/home.nix ];
      "anz-macbook" = mkHome "aarch64-darwin" [ ./machines/anz-macbook/home.nix ];

      # generic (just shared/home.nix, no machine-specific overrides)
      "x86-linux" = mkHome "x86_64-linux" [];
      "arm-linux" = mkHome "aarch64-linux" [];
      "x86-darwin" = mkHome "x86_64-darwin" [];
      "arm-darwin" = mkHome "aarch64-darwin" [];
    };
  };
}
