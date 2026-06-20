{ pkgs, shared, host, ... }:
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
    casks = [ ];
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
      FXPreferredViewStyle = "Nlsv"; # list view by default
      _FXShowPosixPathInTitle = true;
      QuitMenuItem = true; # allow Finder to be quit
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
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

  environment.variables.EDITOR = "nano";
}
