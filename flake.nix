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
    mkHome = system: modules: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./shared/home.nix ] ++ modules;
    };
  in {
    nixosConfigurations = {
      dschana-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          jj-starship = jj-starship.packages.x86_64-linux.default;
        };
        modules = [
          determinate.nixosModules.default
          home-manager.nixosModules.home-manager
          ./shared/configuration.nix
          ./machines/dschana-laptop/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "dschana-laptop" = mkHome "x86_64-linux" [ ./machines/dschana-laptop/home.nix ];
      "anz-macbook" = mkHome "aarch64-darwin" [ ./machines/anz-macbook/home.nix ];
    };
  };
}
