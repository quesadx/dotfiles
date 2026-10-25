{
  pkgs,
  shared,
  ...
}:

{
  # --- GNOME ---
  services = {
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = shared.username;
      };
    };

    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = true;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  security.pam.services.gdm.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs.gnomeExtensions; [
    caffeine
    luminus-desktop
    appindicator
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-weather
    gnome-contacts
    epiphany
    gnome-maps
    gnome-connections
  ];

  # --- Desktop applications and user settings ---
  home-manager.users.${shared.username} = {
    dconf.enable = true;

    home.packages = with pkgs; [
      adwaita-icon-theme
      glib
      gtk3
      dconf-editor
      wl-clipboard
      xournalpp
      deskflow
    ];

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      policies.ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
      };
    };

    programs.chromium = {
      enable = true;
      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell".enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        "luminus-desktop@dikasp.gitlab"
      ];

      "org/gnome/shell/extensions/appindicator".legacy-tray-enabled = false;

      "org/gnome/shell/extensions/caffeine" = {
        restore-state = true;
        enable-fullscreen = false;
      };

      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        xkb-options = [ "compose:rwin" ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        maximize = [ "<Super>F" ];
        minimize = [ "<Super>D" ];
        close = [ "<Super>Q" ];
        switch-to-workspace-left = [ "<Super>h" ];
        switch-to-workspace-right = [ "<Super>l" ];
      };

      "org/gnome/settings-daemon/plugins/power".power-button-action = "nothing";

      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>e" ];
        www = [ "<Super>b" ];
        control-center = [ "<Super>i" ];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kgx";
        name = "gnome-console";
      };

      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
      "org/gnome/desktop/sound".event-sounds = false;
    };

    programs.zed-editor = {
      enable = true;
      enableMcpIntegration = true;

      userSettings = {
        auto_save = "on_focus_change";
        project_panel.flatten_directories = false;
        theme.mode = "system";
      };

      extensions = [
        "java"
        "dockerfile"
        "sql"
        "nix"
        "prisma"
        "docker-compose"
        "ini"
        "pylsp"
        "xml"
        "zedokai"
        "codebook"
        "colored-zed-icons-theme"
      ];

      extraPackages = with pkgs; [
        nixd
        nil
      ];
    };

    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          esbenp.prettier-vscode
          ecmel.vscode-html-css
          humao.rest-client
          vscjava.vscode-java-pack
          james-yu.latex-workshop
          bbenoist.nix
          ms-vscode.live-server
          christian-kohler.path-intellisense
          christian-kohler.npm-intellisense
          mikestead.dotenv
          formulahendry.auto-rename-tag
          formulahendry.auto-close-tag
          shardulm94.trailing-spaces
          prisma.prisma
          pkief.material-icon-theme
          rust-lang.rust-analyzer
          tauri-apps.tauri-vscode
        ];

        userSettings = {
          "workbench.activityBar.location" = "top";
          "workbench.sideBar.location" = "right";
          "workbench.iconTheme" = "material-icon-theme";
          "editor.minimap.enabled" = false;
          "window.commandCenter" = false;
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "files.autoSave" = "onFocusChange";
          "editor.linkedEditing" = true;
          "workbench.editor.scrollToSwitchTabs" = true;
          "workbench.editor.wrapTabs" = true;
          "explorer.confirmDelete" = false;
          "explorer.confirmDragAndDrop" = false;
          "workbench.startupEditor" = "none";
          "git.openRepositoryInParentFolders" = "always";
          "git.enableSmartCommit" = true;
          "git.autofetch" = true;
          "chat.viewSessions.orientation" = "stacked";
          "editor.fontFamily" = "'IBM Plex Mono', monospace";
          "sqldeveloper.telemetry.enabled" = false;
        };
      };
    };
  };
}
