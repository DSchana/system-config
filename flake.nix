{
  description = "NixOS Configuration";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # Use the same nixpkgs
    };
  };

  outputs = { self, determinate, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      dschana-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          determinate.nixosModules.default
          home-manager.nixosModules.home-manager
          #{
          #  nix.settings = {
          #    substituters = [ "https://cosmic.cachix.org/" ];
          #    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          #  };
          #}
          #nixos-cosmic.nixosModules.default
          ./configuration.nix
        ];
      };
    };
  };
}
