{
  description = "Multi-platform dotfiles for NixOS and nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpkgs-26_05.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      shared = import ./shared.nix;
      allHosts = import ./hosts.nix { inherit nixos-hardware; };
      linuxHosts = allHosts.nixos;
      linuxHostNames = builtins.attrNames linuxHosts;
      darwinHosts = allHosts.darwin;
      darwinHostNames = builtins.attrNames darwinHosts;

      linuxHostSystem =
        hostName:
        let
          host = linuxHosts.${hostName};

          linuxBaseModules = [
            ./nixos.nix
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
                inherit inputs;
              };

              home-manager.users.${shared.username} = {
                imports = [ ./home/linux.nix ] ++ (host.homeModules or [ ]);
              };
            }
          ];
        in
        nixpkgs.lib.nixosSystem {
          inherit (shared) system;

          specialArgs = {
            inherit shared;
            inherit host;
            inherit inputs;
          };

          modules = linuxBaseModules ++ linuxHostModules ++ linuxDesktopModules ++ linuxHomeManagerModules;
        };

      darwinSystem =
        hostName:
        let
          host = darwinHosts.${hostName};
          pkgsInputName = host.nixpkgs or "nixpkgs";
          pkgs = inputs.${pkgsInputName};
        in
        nix-darwin.lib.darwinSystem {
          system = host.system;

          specialArgs = {
            inherit shared;
            inherit host;
            inherit inputs;
          };

          modules = [
            {
              nixpkgs.pkgs = import pkgs {
                system = host.system;
                config.allowUnfree = true;
              };
            }
            ./darwin.nix
            ./hosts/darwin.nix
          ] ++ (host.modules or [ ]) ++ [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = {
                inherit shared;
                inherit host;
                inherit inputs;
              };

              home-manager.users.${shared.username} = {
                imports = [ ./home/darwin.nix ] ++ (host.homeModules or [ ]);
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
