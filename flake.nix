{
  description = "Multi-platform dotfiles for NixOS and nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      shared = import ./lib/shared.nix;
      allHosts = import ./hosts.nix { inherit nixos-hardware; };
      linuxHosts = allHosts.nixos;
      linuxHostNames = builtins.attrNames linuxHosts;
      darwinHosts = allHosts.darwin;
      darwinHostNames = builtins.attrNames darwinHosts;

      linuxHostSystem = hostName:
        let
          host = linuxHosts.${hostName};

          linuxBaseModules = [
            ./configuration.nix
            host.hardwareConfig
          ];

          linuxHostModules = host.hardwareModules;
          linuxDesktopModules = host.desktopModules or [ ];

          linuxHomeManagerModules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = {
                inherit shared;
                inherit host;
              };

              home-manager.users.${shared.username} = {
                imports = [ ./home/linux/default.nix ] ++ (host.homeModules or [ ]);
              };
            }
          ];
        in
        nixpkgs.lib.nixosSystem {
          inherit (shared) system;

          specialArgs = {
            inherit shared;
            inherit host;
          };

          modules = linuxBaseModules ++ linuxHostModules ++ linuxDesktopModules ++ linuxHomeManagerModules;
        };

      darwinSystem = hostName:
        let
          host = darwinHosts.${hostName};
        in
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          specialArgs = {
            inherit shared;
            inherit host;
          };

          modules = [
            ./modules/darwin/default.nix
            ./hosts/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = {
                inherit shared;
                inherit host;
              };

              home-manager.users.${shared.username} = {
                imports = [ ./home/darwin/default.nix ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (hostName: {
          name = hostName;
          value = linuxHostSystem hostName;
        }) linuxHostNames
      );

      darwinConfigurations = builtins.listToAttrs (
        map (hostName: {
          name = hostName;
          value = darwinSystem hostName;
        }) darwinHostNames
      );
    };
}
