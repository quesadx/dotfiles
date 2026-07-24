{
  pkgs,
  shared,
  host,
  inputs,
  ...
}:
{
  # --- Nix ---
  nix = {
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        shared.username
      ];
      cores = 0;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  # --- Host ---
  system.primaryUser = shared.username;
  system.stateVersion = 6;

  users.users.${shared.username} = {
    home = "/Users/${shared.username}";
    description = shared.userDescription;
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    nix-tree
    comma
    nixd
    nil
    docker
    colima
  ];

  # --- Home Manager ---
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit shared host inputs; };
  home-manager.users.${shared.username} = {
    imports = [ ./home/darwin.nix ] ++ (host.home or [ ]);
  };
}
