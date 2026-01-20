{
  description = "My first NixOS Flakes config";

  # Repos
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home manager input
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  # 2. Outputs: Lo que produce el Flake (tu sistema)
  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {

      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	  modules = [
          ./configuration.nix
          # ./hardware-configuration.nix 

	  # Mierda de home-manager
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
