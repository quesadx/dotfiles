{ pkgs, shared, ... }:
{
  imports = [
    ./nix-daemon.nix
  ];

  nix = {
    enable = true;
    settings = {
      trusted-users = [
        "root"
        shared.username
      ];
      cores = 0;
      auto-optimise-store = true;
    };
    gc.interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brews = [ ];
    casks = [
      "ghostty"
      "raycast"
    ];
  };

  environment.systemPackages = with pkgs; [
    fd
    jq
    wget
    curl
    starship
    zoxide
    fzf
    ripgrep
    bat
    eza
    delta
    duf
    htop
    gh
    gnupg
    openssh
    nix-tree
    comma
    nixd
    nil
  ];

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      minimize-to-application = true;
      show-recents = false;
    };
    NSGlobalDomain = {
      NSWindowResizeTime = 0.001;
      NSAutomaticWindowAnimationsEnabled = false;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSDocumentSaveNewDocumentsToCloud = false;
    };
    finder = {
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    screencapture.disable-shadow = true;
    trackpad.Clicking = true;
  };

  system.activationScripts.postActivation.text = ''
    pmset -a proximitywake 0
    pmset -a powernap 0
  '';

  environment.variables.EDITOR = "nvim";
}
