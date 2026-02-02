{ config, pkgs, ... }:

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
    fastfetch          # System information fetcher (modern neofetch alternative)
    libnotify          # Desktop notification library
    kitty              # GPU-accelerated terminal emulator
    waybar             # Highly customizable Wayland status bar
    swaynotificationcenter  # Notification daemon for Wayland
    fuzzel             # Application launcher (similar to dmenu/rofi)
    swaybg             # Wallpaper setter for Wayland
    hyprmon            # System monitor widget for Hyprland
    grim               # Screenshot utility for Wayland
    slurp              # Interactive selection tool for screenshots
    wl-clipboard       # Clipboard utilities (wl-copy/wl-paste)
    cliphist           # Clipboard history manager
    imv                # Image viewer for Wayland/X11
    zathura            # Minimal document viewer (PDF, ePub, etc.)
    mpv                # Media player
    onlyoffice-desktopeditors  # Office suite alternative
    unzip unrar p7zip  # Archive extraction tools
    bluetuith          # Bluetooth management TUI
    thunar             # Lightweight file manager
    chromium           # Web browser (alternative to Firefox)
    spotify            # Music streaming client
    obsidian           # Markdown-based knowledge base
    github-copilot-cli # AI pair programmer CLI
    vscode             # Visual Studio Code
    dbeaver-bin        # Universal database tool
    netbeans           # Java IDE
    javaPackages.openjfx21  # JavaFX runtime for JDK 21
    maven              # Build automation tool
    jetbrains.clion    # C/C++ IDE
    gcc cmake          # C/C++ toolchain
    adwaita-icon-theme # Standard GNOME icon theme
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
    "hypr".source = ../.config/hypr;    # Hyprland compositor config
    "kitty".source = ../.config/kitty;    # Terminal emulator config
    "waybar".source = ../.config/waybar;   # Status bar config
    "swaync".source = ../.config/swaync;   # Notification daemon config
    "fuzzel".source = ../.config/fuzzel;   # Application launcher config
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
    # Cursor theme configuration (applies to GTK/Qt apps)
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 24;
    };
  };


  ############################################################
  # DESKTOP ENVIRONMENT THEMING
  ############################################################
  gtk = {
    enable = true;
    # Icon theme (used by GTK applications)
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    # GTK theme with libadwaita styling for modern appearance
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
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
      
      profileExtra = ''
        if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec start-hyprland
        fi
      '';
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
    # SECURITY: SSH
    ########################################################################
    ssh = {
      enable = true;
      addKeysToAgent = "yes";  # Automatically add keys to ssh-agent
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