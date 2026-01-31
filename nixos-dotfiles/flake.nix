{
  description = "Sway on NixOS";

######################
### INPUTS / REPOS ###
######################

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

###############
### OUTPUTS ###
###############

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {

      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	  modules = [
          ./configuration.nix

	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.quesadx = import ./home.nix;
	  }
        ];
      };
    };
  };
}
