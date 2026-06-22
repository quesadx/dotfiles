{
  inputs,
  ...
}:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  dconf.enable = true;

  # --- plasma-manager ---
  programs.plasma = {
    enable = true;

    # --- Mouse settings ---
    input = {
      mice = [
        {
          enable = true;
          name = "Logitech PRO X";
          vendorId = "046d";
          productId = "4093";
          accelerationProfile = "none";
        }
      ];
    };

    # --- Hotkeys ---
    hotkeys.commands = {
      launch-konsole-enter = {
        name = "Launch Konsole";
        key = "Meta+Return";
        command = "konsole";
      };
    };

    # --- Fix that every app re-opens in startup or re-login ---
    session = {
      sessionRestore = {
        restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
    };

    # --- Bottom Panel ---
    panels = [
      {
        location = "bottom";
        height = 48;
        floating = true;

        # --- Individual items on the panel (by order) ---
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.marginsseparator"
          # --- Virtual desktop pager ---
          {
            pager = {
              general = {
                showWindowOutlines = true;
                showApplicationIconsOnWindowOutlines = true;
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          # --- Task icons ---
          {
            iconTasks = {
              behavior.showTasks = {
                onlyInCurrentDesktop = false;
                onlyInCurrentActivity = true;
                onlyInCurrentScreen = false;
                onlyMinimized = false;
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.marginsseparator"
          {
            digitalClock = {
              date.enable = false;

              time = {
                format = "24h";
                showSeconds = "never";
              };

              font = {
                family = "Noto Sans";
                size = 11;
                weight = 400;
                style = "Regular";
                bold = false;
                italic = false;
              };

              calendar = {
                firstDayOfWeek = "monday";
                showWeekNumbers = false;
                plugins = [ ];
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    kwin = {
      # --- Virtual desktop settings ---
      virtualDesktops = {
        names = [
          "main"
          "code"
          "term"
          "docs"
          "chat"
          "scratch"
        ];
        rows = 1;
      };
    };

    # --- Kwin shortcuts ---
    shortcuts.kwin = {
      "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "Switch One Desktop to the Right" = "Meta+Ctrl+Right";

      "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";

      "Switch to Desktop 1" = "Meta+Ctrl+1";
      "Switch to Desktop 2" = "Meta+Ctrl+2";
      "Switch to Desktop 3" = "Meta+Ctrl+3";
      "Switch to Desktop 4" = "Meta+Ctrl+4";
      "Switch to Desktop 5" = "Meta+Ctrl+5";
      "Switch to Desktop 6" = "Meta+Ctrl+6";

      "Window to Desktop 1" = "Meta+Ctrl+Shift+1";
      "Window to Desktop 2" = "Meta+Ctrl+Shift+2";
      "Window to Desktop 3" = "Meta+Ctrl+Shift+3";
      "Window to Desktop 4" = "Meta+Ctrl+Shift+4";
      "Window to Desktop 5" = "Meta+Ctrl+Shift+5";
      "Window to Desktop 6" = "Meta+Ctrl+Shift+6";
    };
  };
}
