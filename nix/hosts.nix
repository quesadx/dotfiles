{ nixos-hardware }:
{
  nixos = {
    desktop = {
      flakeTarget = "desktop";
      hostname = "desktop";
      hardware = ./hardware/desktop.nix;
      hostModules = [
        ./hosts/desktop.nix
      ];
      desktop = [ ./desktop/plasma.nix ];
      home = [ ./desktop/plasma-user.nix ];
    };

    thinkpad = {
      flakeTarget = "thinkpad";
      hostname = "thinkpad-x13";
      hardware = ./hardware/thinkpad.nix;
      hostModules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
      ];
      desktop = [ ./desktop/plasma.nix ];
      home = [ ./desktop/plasma-user.nix ];
    };

    "macbook-pro" = {
      flakeTarget = "macbook-pro";
      hostname = "macbook-pro";
      hardware = ./hardware/macbook-pro.nix;
      hostModules = [
        nixos-hardware.nixosModules.apple-macbook-pro-14-1
        ./hosts/macbook-pro/default.nix
        ./hosts/macbook-pro/audio.nix
      ];
      desktop = [ ./desktop/plasma.nix ];
      home = [ ./desktop/plasma-user.nix ];
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
      hostModules = [
        ./hosts/macbook-pro/darwin.nix
      ];
    };
  };
}
