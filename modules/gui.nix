{ pkgs, ... }: {
  # Habilitar Hyprland (esto instala el compositor y configura Wayland)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # Por si alguna app vieja aún necesita X11
  };

  # Login Manager (TTY-based, muy ligero y moderno)
  services.displayManager.ly.enable = true;

  # Fuentes: Vital para que Waybar y Hyprland se vean bien
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Habilitar sonido (Pipewire es el estándar en Wayland)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
