{ nixos-hardware }:
{
  nixos = {
    desktop = {
      flakeTarget = "desktop";
      hostname = "desktop";
      hardwareConfig = ./hardware/desktop.nix;
      hardwareModules = [
        ./hosts/nix/desktop.nix
      ];
      desktopModules = [ ./modules/desktop/gnome.nix ];
      homeModules = [ ./modules/user/gnome.nix ];
    };

    thinkpad = {
      flakeTarget = "thinkpad";
      hostname = "thinkpad-x13";
      hardwareConfig = ./hardware/thinkpad.nix;
      hardwareModules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
        ./hosts/nix/thinkpad.nix
      ];
      desktopModules = [ ./modules/desktop/gnome.nix ];
      homeModules = [ ./modules/user/gnome.nix ];
    };

    "macbook-pro" = {
      flakeTarget = "macbook-pro";
      hostname = "macbook-pro";
      hardwareConfig = ./hardware/macbook-pro.nix;
      hardwareModules = [
        nixos-hardware.nixosModules.apple-macbook-pro-14-1
        ./hosts/nix/macbook-pro/default.nix
        ./hosts/nix/macbook-pro/audio.nix
      ];
      desktopModules = [ ./modules/desktop/gnome.nix ];
      homeModules = [ ./modules/user/gnome.nix ];
    };
  };

  darwin = {
    "macbook-air" = {
      flakeTarget = "macbook-air";
      hostname = "macbook-air";
    };
  };
}
