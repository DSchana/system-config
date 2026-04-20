{
  description = "NixOS Configuration";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # TODO: Remove once cosmic-settings-daemon and cosmic-applets build on unstable
    # https://github.com/pop-os/cosmic-settings-daemon/pull/139
    nixpkgs-cosmic-pinned.url = "github:NixOS/nixpkgs/cf59864ef8aa2e178cccedbe2c178185b0365705";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    jj-starship.url = "github:dmmulroy/jj-starship";
    jj-starship.inputs.nixpkgs.follows = "nixpkgs";

    #opencode.url = "github:anomalyco/opencode";
    #opencode.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      determinate,
      nixpkgs,
      home-manager,
      nix-darwin,
      jj-starship,
      #opencode,
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

      # TODO: Remove once cosmic-settings-daemon and cosmic-applets build on unstable
      cosmicPinnedOverlay =
        system: final: prev:
        let
          pinnedPkgs = import inputs.nixpkgs-cosmic-pinned {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          cosmic-settings-daemon = pinnedPkgs.cosmic-settings-daemon;
          cosmic-applets = pinnedPkgs.cosmic-applets;
        };

      mkNixosConfiguration =
        { host, system }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            jj-starship = jj-starship.packages.${system}.default;
            #opencode = opencode.packages.${system}.default;
          };
          modules = [
            { nixpkgs.overlays = [ (cosmicPinnedOverlay system) ]; }
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
          specialArgs = {
            jj-starship = jj-starship.packages.${system}.default;
          };
          modules = [
            home-manager.darwinModules.home-manager
            ./dev-machines/${host}/configuration.nix
          ];
        };

      mkNonDevNixosConfiguration =
        { host, system }:
        nixpkgs.lib.nixosSystem {
          inherit system;
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
        "x86-linux" = mkHome "x86_64-linux" [ ];
        "arm-linux" = mkHome "aarch64-linux" [ ];
        "x86-darwin" = mkHome "x86_64-darwin" [ ];
        "arm-darwin" = mkHome "aarch64-darwin" [ ];
      };
    };
}
