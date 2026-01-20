{ pkgs, ... }: {
  programs.git = {
    enable = true;
    # En lugar de userName y userEmail directamente:
    settings = {
      user = {
        name = "Matteo Quesada";
        email = "matteo.vargas.quesada@est.una.ac.cr";
      };
    };
  };
}
