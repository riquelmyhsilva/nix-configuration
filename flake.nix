# flake.nix
{
  description = "NixOS configuration";
  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

  };

  outputs = inputs@{ nixpkgs,  grub2-themes, home-manager, plasma-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        # ... and then to your modules
          modules = [
          ./configuration.nix
          grub2-themes.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rqxm = {
              imports = [ plasma-manager.homeManagerModules.plasma-manager ];
              programs.plasma.enable = true;
              home.stateVersion = "25.05";
            };
          }
        ];
      };
    };
  };
}
