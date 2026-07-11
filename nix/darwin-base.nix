{
  pkgs,
  shared,
  host,
  inputs,
  ...
}:
{
  imports = [ ];

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
  networking.hostName = host.hostname;
  system.primaryUser = shared.username;
  system.stateVersion = 6;

  users.users.${shared.username} = {
    home = "/Users/${shared.username}";
    description = shared.userDescription;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";

      extraFlags = [
        "--force"
      ];
    };

    casks = [
      "spotify"
      "obsidian"
      "discord"
      "firefox@developer-edition"
      "onlyoffice"
    ];
  };

  environment.systemPackages = with pkgs; [
    nix-tree
    comma
    nixd
    nil

    docker
    colima
  ];

  system.defaults = {
    finder = {
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf"; # search current folder by default
      _FXShowPosixPathInTitle = true;
      QuitMenuItem = true; # allow Finder to be quit
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
  };

  environment.variables.EDITOR = "nano";

  # --- Home Manager ---
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit shared host inputs; };
  home-manager.users.${shared.username} = {
    imports = [ ./home/darwin.nix ] ++ (host.home or [ ]);
  };
}
