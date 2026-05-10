{ nixos-hardware }:
{
  desktop = {
    flakeTarget = "desktop";
    hostname = "desktop";
    hardwareConfig = ./hardware/desktop.nix;
    hardwareModules = [];
    desktopModules = [ ./modules/system/desktop-gnome.nix ];
    homeModules = [ ./modules/home/desktop-gnome-user.nix ];
  };

  thinkpad = {
    flakeTarget = "thinkpad";
    hostname = "thinkpad-x13";
    hardwareConfig = ./hardware/thinkpad.nix;
    hardwareModules = [
      nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
      ./modules/hosts/thinkpad.nix
    ];
    desktopModules = [ ./modules/system/desktop-gnome.nix ];
    homeModules = [ ./modules/home/desktop-gnome-user.nix ];
  };

  "macbook-pro" = {
    flakeTarget = "macbook-pro";
    hostname = "macbook-pro";
    hardwareConfig = ./hardware/macbook-pro.nix;
    hardwareModules = [
      nixos-hardware.nixosModules.apple-macbook-pro-14-1
      ./modules/hosts/macbook-pro/default.nix
      ./modules/hosts/macbook-pro/audio.nix
    ];
    desktopModules = [ ./modules/system/desktop-gnome.nix ];
    homeModules = [ ./modules/home/desktop-gnome-user.nix ];
  };
}
