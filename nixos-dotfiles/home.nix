{ config, pkgs, lib, ... }:

let
  ############################################################
  # USER IDENTITY & PERSONAL INFORMATION
  ############################################################
  username = "quesadx";
  homeDir = "/home/quesadx";
  
  # Git identity for commits and version control
  gitUser = {
    name = "Matteo Quesada";
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };


  ############################################################
  # APPLICATION CONFIGURATIONS
  ############################################################
  firefoxExtensions = {
    # uBlock Origin - Privacy-focused ad blocker
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    
    # Bitwarden - Password manager integration
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      installation_mode = "force_installed";
    };
  };


  ############################################################
  # PACKAGE SELECTION BY CATEGORY
  ############################################################
  userPackages = with pkgs; [
    # System & Desktop
    fastfetch
    adwaita-icon-theme

    # File Management
    nautilus
    file-roller
    unzip unrar p7zip

    # Media
    showtime
    gnome-photos
    gnome-music
    spotify

    # Documents & Utilities
    papers
    onlyoffice-desktopeditors
    gnome-calculator
    gnome-text-editor
    gnome-font-viewer
    gnome-console

    # Applications
    google-chrome
    obsidian
    github-copilot-cli
    thunderbird

    # Development: IDEs & Tools
    vscode
    dbeaver-bin
    jetbrains.clion

    # Development: Environment
    direnv
    nix-direnv
  ];

  gnome-extensions-enabled = [
    "AlphabeticalAppGrid@stuarthayhurst"
    "CoverflowAltTab@palatis.blogspot.com"
    "appindicatorsupport@rgcjonas.gmail.com"
    "auto-accent-colour@Wartybix"
    "caffeine@patapon.info"
    "clipboard-history@alexsaveau.dev"
    "grand-theft-focus@zalckos.github.com"
    "hidetopbar@mathieu.bidon.ca"
    "impatience@gfxmonk.net"
    "luminus-desktop@dikasp.gitlab"
    "top-bar-organizer@julian.gse.jsts.xyz"
  ];


  ############################################################
  # SHELL CUSTOMIZATION
  ############################################################
  bashAliases = {
    ll = "ls -l";                          # Detailed directory listing
    gs = "git status";                     # Check Git status
    ga = "git add .";                      # Stage all changes
    gc = "git commit -m";                  # Commit with message (requires argument)
    gp = "git push";                       # Push changes to remote
    nrt = "cd ~/dotfiles/nixos-dotfiles && sudo nixos-rebuild test --flake .#nixos";
                                           # Test rebuild without activation
    nrs = "cd ~/dotfiles && git add . && cd nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
                                           # Commit changes and activate new config
  };


  ############################################################
  # DOTFILES MANAGEMENT
  ############################################################
  # Symlink configuration directories from dotfiles repository
  # Paths are relative to the Home Manager module location
  configSources = {
    "fastfetch".source = ../.config/fastfetch;  # System info display config
  };

in {

  ############################################################
  # HOME MANAGER CORE SETTINGS <><><><><><><><><><><><><><><><
  ############################################################
  home = {
    username = username;
    homeDirectory = homeDir;
    stateVersion = "26.05";
    # Installed packages for this user
    packages = userPackages;
  };


  ############################################################
  # DESKTOP ENVIRONMENT THEMING
  ############################################################
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # xkb-options = [ "ctrl:nocaps" ]; emacs pinky btw
    };
    "org/gnome/shell" = {
      enabled-extensions = gnome-extensions-enabled;
    };

    # GNOME Extensions Settings
    # Can be found using 'dconf watch /org/gnome/shell/extensions/'
    "org/gnome/shell/extensions/alphabetical-app-grid" = {
      folder-order-position = "start";
    };
    "org/gnome/shell/extensions/appindicator" = {
      legacy-tray-enabled = false;
    };
    "org/gnome/shell/extensions/caffeine" = {
      restore-state = true;
      enable-fullscreen = false;
    };
    "org/gnome/shell/extensions/coverflowalttab" = {
      current-workspace-only = "all";
    };
    "org/gnome/shell/extensions/hidetopbar" = {
      hot-corner = true;
      enable-active-window = false;
      animation-time-overview = 0.2;
      animation-time-autohide = 0.2;
    };
    "org/gnome/shell/extensions/net/gfxmonk/impatience" = {
      speed-factor = 1.2;
    };

    # GNOME general settings
    # Can be found using 'dconf watch /org/gnome/'
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];
      www = [ "<Super>b" ];
      control-center = [ "<Super>i" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Super>F" ];
      minimize = [ "<Super>D" ];
      close = [ "<Super>Q" ];
    };
    # Power button behavior
     "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
    };
    # Input layout
    "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        sources = [ # Needs 'lib' to build GVariant tuples
          (lib.gvariant.mkTuple ["xkb" "us+altgr-intl"])
        ];
      };

    # Custom shortcuts
    "org/gnome/settings-daemon/plugins/media-keys" = {
      # 1. Register the custom shortcut path
      # These MUST have the leading and trailing slashes as strings
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    # 2. Define the shortcut details
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kgx";
      name = "gnome-console";
    };

    # GNOME misc setting
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.21;
    };
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
  };
  ############################################################
  # CONFIGURATION FILE MANAGEMENT
  ############################################################
  # Create symlinks for dotfiles in XDG_CONFIG_HOME (~/.config)
  xdg.configFile = configSources;


  ############################################################
  # PROGRAM CONFIGURATIONS
  ############################################################
  programs = {
    # Required to enable Home Manager module system
    home-manager.enable = true;

    ########################################################################
    # SHELL: BASH
    ########################################################################
    bash = {
      enable = true;
      shellAliases = bashAliases;      
    };


    ########################################################################
    # VERSION CONTROL: GIT
    ########################################################################
    git = {
      enable = true;
      settings = {
        user = gitUser;
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };


    ########################################################################
    # DIRENV: Auto-load development environments
    ########################################################################
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };


    ########################################################################
    # SECURITY: SSH
    ########################################################################
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
    };
};


    ########################################################################
    # BROWSER: FIREFOX
    ########################################################################
    firefox = {
      enable = true;
      profiles.${username} = {
        isDefault = true;
        settings = {
          "browser.search.region" = "CR";
          "browser.search.isUS" = false;
          "distribution.id" = "nixos";
        };
      };
      # Enforce extension installation via enterprise policy
      policies.ExtensionSettings = firefoxExtensions;
    };


    ########################################################################
    # DEVELOPMENT: JAVA
    ########################################################################
    java = {
      enable = true;
      package = pkgs.jdk21.override { enableJavaFX = true; };  # JDK 21 with JavaFX
    };
  };

  ############################################################
  # USER SERVICES
  ############################################################
  services.ssh-agent.enable = true;


  ############################################################
  # OPTIONAL ENHANCEMENTS
  ############################################################
  programs.starship.enable = true;  # Modern shell prompt
  programs.zsh.enable = true;       # Alternative to bash

}
