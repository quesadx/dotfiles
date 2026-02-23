{ config, pkgs, lib, ... }:

let
  username = "quesadx";
  homeDir = "/home/quesadx";
  gitUser = {
    name = "Matteo Quesada";
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };

  firefoxExtensions = {
    "uBlock0@raymondhill.net" = { # uBlock Origin
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = { # Bitwarden
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      installation_mode = "force_installed";
    };
  };

  userPackages = with pkgs; [
    file-roller unzip unrar p7zip
    gnome-photos gnome-music gnome-calculator gnome-text-editor gnome-font-viewer gnome-console nautilus adwaita-icon-theme
    fastfetch papers showtime rnote dconf-editor
    onlyoffice-desktopeditors google-chrome thunderbird spotify obsidian github-copilot-cli
    vscode jetbrains.clion direnv nix-direnv
    input-leap distrobox
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

  bashAliases = {
    ll = "ls -l";
    ls = "ls -a --color=auto";
    # Git shortcuts
    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";
    # NixOS rebuild shortcuts
    nrt = "cd ~/dotfiles/nixos-dotfiles && sudo nixos-rebuild test --flake .#nixos";
    nrs = "cd ~/dotfiles && git add . && cd nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
  };

  configSources = {
    "fastfetch".source = ../.config/fastfetch;
  };

in {

  home = {
    username = username;
    homeDirectory = homeDir;
    stateVersion = "26.05";
    packages = userPackages;
  };

  xdg.configFile = configSources;

  programs = {
    home-manager.enable = true;
    starship.enable = true;
    zsh.enable = true;

    bash = {
      enable = true;
      shellAliases = bashAliases;      
    };

    git = {
      enable = true;
      settings = {
        user = gitUser;
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
      };
    };

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

    # java = {
      # enable = true;
      # package = pkgs.jdk21.override { enableJavaFX = true; };
    # };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/input-sources" = {
        # xkb-options = [ "ctrl:nocaps" ]; emacs pinky btw
      };
      "org/gnome/shell" = {
        enabled-extensions = gnome-extensions-enabled;
      };

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

      # GNOME general settings. Can be found using 'dconf watch /org/gnome/'
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
      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "nothing";
      };
      "org/gnome/desktop/input-sources" = {
          show-all-sources = true;
          sources = [ # Needs 'lib' to build GVariant tuples
            (lib.gvariant.mkTuple ["xkb" "us+altgr-intl"])
          ];
        };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kgx";
        name = "gnome-console";
      };
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
        speed = 0.21;
      };
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
    };
  };

  services.ssh-agent.enable = true;

}
