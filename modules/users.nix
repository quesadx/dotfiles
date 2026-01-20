{ pkgs, ... }: {
  users.users.quesadx = {
    isNormalUser = true;
    description = "Matteo Quesada";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Paquetes mínimos del SISTEMA (no de usuario)
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
  ];
}
