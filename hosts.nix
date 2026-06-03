{ nixos-hardware }:
{
  nixos = {
    desktop = {
      flakeTarget = "desktop";
      hostname = "desktop";
      hardwareConfig = ./nix/hardware/desktop.nix;
      hardwareModules = [
        ./nix/hosts/desktop.nix
      ];
      desktopModules = [ ./nix/modules/desktop/gnome.nix ];
      homeModules = [ ./nix/modules/user/gnome.nix ];
    };

    thinkpad = {
      flakeTarget = "thinkpad";
      hostname = "thinkpad-x13";
      hardwareConfig = ./nix/hardware/thinkpad.nix;
      hardwareModules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
        ./nix/hosts/thinkpad.nix
      ];
      desktopModules = [ ./nix/modules/desktop/gnome.nix ];
      homeModules = [ ./nix/modules/user/gnome.nix ];
    };

    "macbook-pro" = {
      flakeTarget = "macbook-pro";
      hostname = "macbook-pro";
      hardwareConfig = ./nix/hardware/macbook-pro.nix;
      hardwareModules = [
        nixos-hardware.nixosModules.apple-macbook-pro-14-1
        ./nix/hosts/macbook-pro/default.nix
        ./nix/hosts/macbook-pro/audio.nix
      ];
      desktopModules = [ ./nix/modules/desktop/gnome.nix ];
      homeModules = [ ./nix/modules/user/gnome.nix ];
    };
  };

  darwin = {
    "macbook-air" = {
      flakeTarget = "macbook-air";
      hostname = "macbook-air";
    };
  };
}
