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
      upgrade = true;
      cleanup = "zap";

      extraFlags = [
        "--force"
      ];
    };
    casks = [
      "ghostty"
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
      autohide = false;
      minimize-to-application = true;
      show-recents = false;
      mru-spaces = false; # don't reorder spaces by recent use
      expose-group-apps = true;
    };

    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true; # expanded save dialog by default
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true; # expanded print dialog
      PMPrintingExpandedStateForPrint2 = true;
      AppleShowAllExtensions = true;
      AppleICUForce24HourTime = true;
      _HIHideMenuBar = false;
    };

    finder = {
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf"; # search current folder by default
      FXPreferredViewStyle = "Nlsv"; # list view by default
      _FXShowPosixPathInTitle = true;
      QuitMenuItem = true; # allow Finder to be quit
    };

    screencapture = {
      disable-shadow = true;
      location = "~/Desktop/screenshots"; # or wherever you want
      type = "png";
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = false;
    };

    spaces.spans-displays = false; # separate spaces per display

    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

    ActivityMonitor.IconType = 5; # show CPU history in dock icon
  };

  system.activationScripts.postActivation.text = ''
    # power
    pmset -a proximitywake 0
    pmset -a powernap 0
    pmset -a tcpkeepalive 0
    pmset -a womp 0             # wake on network access

    # disable crash reporter
    defaults write com.apple.CrashReporter DialogType none

    # disable telemetry / diagnostics submission
    defaults write com.apple.SubmitDiagInfo AutoSubmit -bool false
    defaults write com.apple.spindump DisableSpindump -bool true

    # disable automatic termination of inactive apps
    defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

    # disable smart quotes and dashes (destroys code pasting)
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  '';

  environment.variables.EDITOR = "nvim";
}
