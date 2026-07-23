{ pkgs, ... }:

{
  xfconf.settings = {
    # --- Window Manager (xfwm4) shortcuts ---
    xfwm4 = {
      "/general/close" = "<Super>q";
      "/general/toggle_maximized" = "<Super>f";
      "/general/show_desktop" = "<Super>d";
      "/general/workspace_left" = "<Control><Alt>Left";
      "/general/workspace_right" = "<Control><Alt>Right";
      "/general/cycle_windows_key" = "<Alt>Tab";
      "/general/cycle_windows" = "<Super>Tab";
      "/general/cycle_windows_key_reverse" = "<Shift><Alt>Tab";
      "/general/cycle_windows_reverse" = "<Shift><Super>Tab";
    };

    # --- Keyboard shortcuts for launching applications ---
    "xfce4-keyboard-shortcuts" = {
      "/commands/custom/Super-t" = "exo-open --launch TerminalEmulator";
      "/commands/custom/Super-e" = "exo-open --launch FileManager";
      "/commands/custom/Super-b" = "exo-open --launch WebBrowser";
      "/commands/custom/Super-i" = "xfce4-settings-manager";
      "/commands/custom/<Super>l" = "dm-tool lock";
    };

    # --- Session settings ---
    xfce4-session = {
      "/startup/ssh-agent/enabled" = false;
      "/general/LockCommand" = "${pkgs.lightdm}/bin/dm-tool lock";
    };

    # --- Appearance settings ---
    xsettings = {
      "/Net/ThemeName" = "Adwaita-dark";
      "/Net/IconThemeName" = "Adwaita";
      "/Gtk/CursorThemeName" = "Adwaita";
      "/Gtk/DecorationLayout" = "close,maximize,minimize:menu";
    };
  };
}
