{
  description = "Hyprland Desktop Environment on NixOS";

  ############################################################################
  # INPUT SOURCES: External Dependencies & Channel Management
  ############################################################################
  inputs = {
    # Primary Nixpkgs channel - unstable for latest packages & Hyprland support
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home Manager - User environment management (dotfiles, user packages, etc.)
    home-manager = {
      url = "github:nix-community/home-manager";
      # Critical: Ensure Home Manager uses SAME nixpkgs revision as system
      # Prevents version mismatches between system/user packages
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  ############################################################################
  # OUTPUT DEFINITIONS: System & User Environment Composition
  ############################################################################
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # SYSTEM ARCHITECTURE CONFIGURATION
      system = "x86_64-linux";
      # HOST & USER IDENTIFIERS
      # These values must match your actual system configuration
      hostname = "nixos";    # Must match networking.hostName in configuration.nix
      username = "quesadx";  # Must match users.users.<name> in configuration.nix
      
    in {


    ############################################################################
    # NIXOS SYSTEM CONFIGURATION
    # Defines the entire OS environment (kernel, services, hardware, etc.)
    ############################################################################
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      # MODULE COMPOSITION: Layered configuration approach
      modules = [
        # PRIMARY SYSTEM CONFIGURATION
        # Contains core OS settings: bootloader, networking, users, services
        ./configuration.nix


        ############################################################################
        # HOME MANAGER INTEGRATION LAYER
        # Bridges system configuration with user environment management
        ############################################################################
        home-manager.nixosModules.home-manager {
          # Use system-wide nixpkgs for user packages (consistent versions)
          home-manager.useGlobalPkgs = true;
          # Enable user-specific packages defined in home.nix
          home-manager.useUserPackages = true;
          # Map Home Manager configuration to specific user account
          home-manager.users.${username} = import ./home.nix;
        }
      ];
    };   
  };
  
}