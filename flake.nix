{
  description = "Minimal NixOS dotfiles for a desktop and a ThinkPad server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
    let
      shared = {
        username = "quesadx";
        userDescription = "Matteo Quesada";
        timeZone = "America/Costa_Rica";
        locale = "en_US.UTF-8";
        regionalLocale = "es_CR.UTF-8";
      };

      mkHost = name: hostModule: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit shared nixos-hardware; host = name; };
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/system.nix
          hostModule
        ];
      };
    in
    {
      nixosConfigurations = {
        i5-9400-desktop = mkHost "i5-9400-desktop" ./hosts/i5-9400-desktop.nix;
        thinkpad-x13-gen2 = mkHost "thinkpad-x13-gen2" ./hosts/thinkpad-x13-gen2.nix;
      };
    };
}
