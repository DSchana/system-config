{
  description = "NixOS Configuration";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    jj-starship.url = "github:dmmulroy/jj-starship";
    jj-starship.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      determinate,
      nixpkgs,
      home-manager,
      nix-darwin,
      jj-starship,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems =
        f:
        builtins.listToAttrs (
          map (name: {
            inherit name;
            value = f name;
          }) systems
        );

      mkNixosConfiguration =
        { host, system }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            jj-starship = jj-starship.packages.${system}.default;
          };
          modules = [
            determinate.nixosModules.default
            home-manager.nixosModules.home-manager
            ./dev-shared/configuration.nix
            ./dev-machines/${host}/configuration.nix
          ];
        };

      mkDawrinConfiguration =
        { host, system }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            home-manager.darwinModules.home-manager
            ./dev-machines/${host}/configuration.nix
          ];
        };

      mkNonDevNixosConfiguration =
        { host, system }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            jj-starship = jj-starship.packages.${system}.default;
          };
          modules = [
            determinate.nixosModules.default
            home-manager.nixosModules.home-manager
            ./non-dev-shared/configuration.nix
            ./non-dev-machines/${host}/configuration.nix
          ];
        };

      mkHome =
        system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ ./dev-shared/home.nix ] ++ modules;
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      nixosConfigurations = {
        ## Dev machines ##
        dschana-laptop = mkNixosConfiguration {
          host = "dschana-laptop";
          system = "x86_64-linux";
        };
        dschana-desktop = mkNixosConfiguration {
          host = "dschana-desktop";
          system = "x86_64-linux";
        };

        ## Non-dev machines ##
        lenovo-laptop = mkNonDevNixosConfiguration {
          host = "lenovo-laptop";
          system = "x86_64-linux";
        };
      };

      darwinConfigurations = {
        anz-macbook = mkDawrinConfiguration {
          host = "anz-macbook";
          system = "aarch64-darwin";
        };
      };

      homeConfigurations = {
        # generic (just shared/home.nix, no machine-specific overrides)
        "x86-linux" = mkHome "x86_64-linux" [ ];
        "arm-linux" = mkHome "aarch64-linux" [ ];
        "x86-darwin" = mkHome "x86_64-darwin" [ ];
        "arm-darwin" = mkHome "aarch64-darwin" [ ];
      };
    };
}
