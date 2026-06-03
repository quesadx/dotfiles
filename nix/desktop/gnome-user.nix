{ ... }:

{
  dconf.enable = true;

  dconf.settings = {
    # --- GNOME Shell Extensions ---
    "org/gnome/shell".enabled-extensions = [
      "appindicatorsupport@rgcjonas.gmail.com"
      "caffeine@patapon.info"
      "luminus-desktop@dikasp.gitlab"
      "touchpad-gesture-customization@coooolapps.com"
    ];

    # --- Extension: AppIndicator (System Tray) ---
    "org/gnome/shell/extensions/appindicator".legacy-tray-enabled = false;

    # --- Extension: Caffeine ---
    "org/gnome/shell/extensions/caffeine" = {
      restore-state = true;
      enable-fullscreen = false;
    };

    # --- Input Sources (Keyboard Layouts) ---
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      xkb-options = [ "compose:rwin" ];
    };

    # --- Window Manager Keybindings ---
    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Super>F" ];
      minimize = [ "<Super>D" ];
      close = [ "<Super>Q" ];
      switch-to-workspace-left = [ "<Super>h" ];
      switch-to-workspace-right = [ "<Super>l" ];
    };

    # --- Power & System Settings ---
    "org/gnome/settings-daemon/plugins/power".power-button-action = "nothing";

    # --- Media Key Bindings ---
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];
      www = [ "<Super>b" ];
      control-center = [ "<Super>i" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    # --- Custom Keybinding: Super+T = Terminal ---
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kgx";
      name = "gnome-console";
    };

    # --- Extension: Touchpad Gesture Customization ---
    "org/gnome/shell/extensions/touchpad-gesture-customization" = {
      overview-navigation-states = "GNOME";
      horizontal-swipe-3-fingers-gesture = "WORKSPACE_SWITCHING";
      horizontal-swipe-4-fingers-gesture = "WORKSPACE_SWITCHING";
      vertical-swipe-4-fingers-gesture = "WINDOW_MANIPULATION";
      pinch-3-finger-gesture = "NONE";
      pinch-4-finger-gesture = "NONE";
    };

    # --- Mouse & Accessibility ---
    "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
    "org/gnome/desktop/sound".event-sounds = false;
  };
}
