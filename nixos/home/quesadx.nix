{
  pkgs,
  shared,
  host,
  ...
}:

let
  bashAliases = {
    ll = "ls -l";
    ls = "ls -a --color=auto";

    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";

    nrt = "cd ~/linux-dotfiles/nixos && sudo nixos-rebuild test --flake .#${host.flakeTarget}";
    nrs = "cd ~/linux-dotfiles && git add . && cd nixos && sudo nixos-rebuild switch --flake .#${host.flakeTarget}";

    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcd = "docker compose down";
    dcdv = "docker compose down -v";

    dotfiles = "cd ~/linux-dotfiles";
  };
in
{
  # --- Home manager core stuff ---
  programs.home-manager.enable = true;
  home.username = shared.username;
  home.homeDirectory = "/home/${shared.username}";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    gnome-tweaks
    gnome-software
    gnome-music
    gnome-calendar
    gnome-calculator
    gnome-text-editor
    gnome-console
    gnome-font-viewer
    showtime
    nautilus
    papers
    loupe
    adwaita-icon-theme
    glib
    gtk3
    onlyoffice-desktopeditors
    dconf-editor
    direnv
    nix-direnv
    fastfetch
    wl-clipboard
    xournalpp
    rnote
  ];
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  # --- Services ---
  services.ssh-agent.enable = true;

  # --- zsh & bash ---
  programs.zsh.enable = true;
  programs.zsh.shellAliases = bashAliases;
  programs.bash.enable = true;
  programs.bash.shellAliases = bashAliases;
  programs.starship.enable = true;

  # --- Git ---
  programs.git.enable = true;
  programs.git.package = pkgs.gitFull;
  programs.git.settings.user = {
    name = "Matteo Quesada";
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };
  programs.git.settings.init.defaultBranch = "main";
  programs.git.settings.pull.rebase = true;
  programs.git.settings.credential.helper = "libsecret";

  # --- direnv: for flake auto-loading on shell ---
  programs.direnv.enable = true;
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  # --- SSH ---
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings."*".addKeysToAgent = "yes";

  # --- Chromium ---
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };

  # ─── Zed ---
  programs.zed-editor.enable = true;
  programs.zed-editor.enableMcpIntegration = true;
  programs.zed-editor.userSettings = {
    auto_save = "on_focus_change";
    theme = {
      mode = "system"; # or "light" / "dark"
      light = "Zedokai Light";
      dark = "Zedokai Dark";
    };
  };
  programs.zed-editor.extensions = [
    "java"
    "dockerfile"
    "sql"
    "gemini"
    "opencode"
    "nix"
    "prisma"
    "docker-compose"
    "github-copilot-cli"
    "qwen-code"
    "claude-acp"
    "opencode"
    "ini"
    "pylsp"
    "xml"
    "zedokai"
    "codebook"
    "colored-zed-icons-theme"
  ];
  programs.zed-editor.extraPackages = with pkgs; [
    nixd
  ];

  # --- VSCode ---
  programs.vscode.enable = true;
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    esbenp.prettier-vscode
    ecmel.vscode-html-css
    humao.rest-client
    ms-python.python
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
  ];
  programs.vscode.profiles.default.userSettings = {
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
}
