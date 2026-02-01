{ config, pkgs, ... }:

let
  # User Information
  username = "quesadx";
  homeDir = "/home/quesadx";
  
  # Git Configuration
  gitUser = {
    name = "Matteo Quesada";
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };

  # Firefox Extensions
  firefoxExtensions = {
    # uBlock Origin
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    # Bitwarden
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      installation_mode = "force_installed";
    };
  };

  # User Packages
  userPackages = with pkgs; [
    # System utilities
    zoxide fastfetch stow libnotify
    
    # Hyprland components
    kitty waybar swaynotificationcenter fuzzel swaybg

    # File utilities
    imv zathura mpv onlyoffice-desktopeditors unzip unrar p7zip
    
    # Screenshot & clipboard
    grim slurp wl-clipboard cliphist
    
    # Bluetooth
    bluetuith
    
    # Applications
    thunar chromium spotify obsidian
    
    # Development
    github-copilot-cli vscode dbeaver-bin
      # Java
      netbeans javaPackages.openjfx21 maven
      # C++
      jetbrains.clion gcc cmake

    # Theming
    adwaita-icon-theme
    
    # Monitoring
    hyprmon
  ];

  # Shell Aliases
  bashAliases = {
    ll = "ls -l";
    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";
    nrt = "cd ~/dotfiles/nixos-dotfiles && sudo nixos-rebuild test --flake .#nixos";
    nrs = "cd ~/dotfiles && git add . && cd nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
  };

  # Dotfiles Configuration Paths
  configSources = {
    "hypr".source = ../.config/hypr;
    "kitty".source = ../.config/kitty;
    "waybar".source = ../.config/waybar;
    "swaync".source = ../.config/swaync;
    "fuzzel".source = ../.config/fuzzel;
    "fastfetch".source = ../.config/fastfetch;
  };
in 

{
  # Home Manager Settings
  home = {
    username = username;
    homeDirectory = homeDir;
    packages = userPackages;
    stateVersion = "26.05";
    
    # Cursor Theme
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 24;
    };
  };

  # Symlink Configuration Files
  xdg.configFile = configSources;

  # GTK Theme
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
  };

  # Programs Configuration
  programs = {
    home-manager.enable = true;

    # Bash Shell
    bash = {
      enable = true;
      shellAliases = bashAliases;
      profileExtra = ''
        if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec start-hyprland
        fi
      '';
    };

    # Git
    git = {
      enable = true;
      settings.user = gitUser;
    };

    # SSH
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    # Firefox
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
      policies.ExtensionSettings = firefoxExtensions;
    };

    # Java (jdk-21)
    java = {
      enable = true;
      package = pkgs.jdk21.override { enableJavaFX = true; };
    };

  };

  # Services
  services.ssh-agent.enable = true;

}
