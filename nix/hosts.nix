{ nixos-hardware }:
{
  nixos = {
    desktop = {
      flakeTarget = "desktop";
      hostname = "desktop";
      hardwareConfig = ./hardware/desktop.nix;
      hardwareModules = [
        ./hosts/desktop.nix
      ];
      desktopModules = [ ./desktop/gnome.nix ];
      homeModules = [ ./desktop/gnome-user.nix ];
    };

    thinkpad = {
      flakeTarget = "thinkpad";
      hostname = "thinkpad-x13";
      hardwareConfig = ./hardware/thinkpad.nix;
      hardwareModules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
        ./hosts/thinkpad.nix
      ];
      desktopModules = [ ./desktop/gnome.nix ];
      homeModules = [ ./desktop/gnome-user.nix ];
    };

    "macbook-pro" = {
      flakeTarget = "macbook-pro";
      hostname = "macbook-pro";
      hardwareConfig = ./hardware/macbook-pro.nix;
      hardwareModules = [
        nixos-hardware.nixosModules.apple-macbook-pro-14-1
        ./hosts/macbook-pro/default.nix
        ./hosts/macbook-pro/audio.nix
      ];
      desktopModules = [ ./desktop/gnome.nix ];
      homeModules = [ ./desktop/gnome-user.nix ];
    };
  };

  darwin = {
    "macbook-air" = {
      flakeTarget = "macbook-air";
      hostname = "macbook-air";
      system = "aarch64-darwin";
    };
    "macbook-pro" = {
      flakeTarget = "macbook-pro";
      hostname = "macbook-pro";
      system = "x86_64-darwin";
    };
  };
}
