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
      shared = import ./nixos/lib/shared.nix;
      linuxHosts = import ./nixos/hosts.nix { inherit nixos-hardware; };
      linuxHostNames = builtins.attrNames linuxHosts;

      linuxHostSystem = hostName:
        let
          host = linuxHosts.${hostName};

          linuxBaseModules = [
            ./modules/linux/default.nix
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
                imports = [ ./nixos/home/quesadx.nix ] ++ (host.homeModules or [ ]);
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

      darwinHost = {
        flakeTarget = "macbook-air";
        hostname = "macbook-air";
      };

      darwinSystem = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        specialArgs = {
          inherit shared;
          host = darwinHost;
        };

        modules = [
          ./modules/darwin/default.nix
          ./hosts/darwin/macbook-air/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit shared;
              host = darwinHost;
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

      darwinConfigurations.macbook-air = darwinSystem;
    };
}