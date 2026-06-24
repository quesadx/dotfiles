{
  description = "Multi-platform dotfiles for NixOS and nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    kyanite = {
      url = "github:MurderFromMars/Kyanite";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ nixpkgs, nix-darwin, home-manager, plasma-manager, kyanite, nixos-hardware, ... }:
  let
    shared = import ./shared.nix;
    allHosts = import ./hosts.nix { inherit nixos-hardware; };

    mkSpecialArgs = host: { inherit shared host; inherit inputs; };
  in
  {
    nixosConfigurations = builtins.mapAttrs (_: host:
      nixpkgs.lib.nixosSystem {
        inherit (shared) system;
        specialArgs = mkSpecialArgs host;
        modules =
          [ ./nixos.nix host.hardware ] ++ host.hostModules ++ (host.desktop or [])
          ++ [ home-manager.nixosModules.home-manager ];
      }
    ) allHosts.nixos;

    darwinConfigurations = builtins.mapAttrs (_: host:
      nix-darwin.lib.darwinSystem {
        system = host.system;
        specialArgs = mkSpecialArgs host;
        modules =
          [ ./darwin.nix ] ++ (host.hostModules or [])
          ++ [ home-manager.darwinModules.home-manager ];
      }
    ) allHosts.darwin;
  };
}
