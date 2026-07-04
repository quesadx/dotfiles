{ nixos-hardware }:
{
  nixos = {
    "i5-9400-desktop" = {
      flakeTarget = "i5-9400-desktop";
      hostname = "i5-9400-desktop";
      hardware = ./hardware/i5-9400-desktop.nix;
      hostModules = [
        ./host-specific/i5-9400-desktop.nix
      ];
      desktop = [ ./desktop/gnome.nix ];
      home = [ ./desktop/gnome-user.nix ];
    };

    "thinkpad-x13-gen2" = {
      flakeTarget = "thinkpad-x13-gen2";
      hostname = "thinkpad-x13-gen2";
      hardware = ./hardware/thinkpad-x13-gen2.nix;
      hostModules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
      ];
      desktop = [ ./desktop/plasma.nix ];
      home = [ ./desktop/plasma-user.nix ];
    };

    "macbook-pro-2017" = {
      flakeTarget = "macbook-pro-2017";
      hostname = "macbook-pro-2017";
      hardware = ./hardware/macbook-pro-2017.nix;
      hostModules = [
        nixos-hardware.nixosModules.apple-macbook-pro-14-1
        ./host-specific/macbook-pro-2017/default.nix
        ./host-specific/macbook-pro-2017/audio.nix
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
    "macbook-pro-m1-pro" = {
      flakeTarget = "macbook-pro-m1-pro";
      hostname = "macbook-pro-m1-pro";
      system = "aarch64-darwin";
    };
  };
}
