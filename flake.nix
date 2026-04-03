{
  description = ''
    nixos config y540
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # nixos hardware for laptop
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # preservation
    preservation = {
      url = "github:nix-community/preservation";
    };

    # dotfiles git repo
    dotfiles = {
      url = "github:weistable/dotfiles";
      flake = false;
    };
  };

  outputs = { self, preservation, nixos-hardware, home-manager, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        gp2e-pc = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/gp2e-pc
            preservation.nixosModules.default
          ];
        };
      };
      homeConfigurations = {
        "nec@gp2e-pc" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/nec/gp2e-pc.nix ];
        };
      };
    };
}
