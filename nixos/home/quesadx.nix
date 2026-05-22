{
  pkgs,
  shared,
  host,
  ...
}:

# ─── VARIABLES ───────────────────────────────────────────────────────────
# User packages, aliases, and configurations

let
  username = shared.username;
  homeDir = "/home/${username}";

  # ─── GIT CONFIGURATION ─────────────────────────────────────────────────────
  gitUser = {
    name = "Matteo Quesada";
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };

  # ─── SHELL ALIASES ────────────────────────────────────────────────────────
  bashAliases = {
    ll = "ls -l";
    ls = "ls -a --color=auto";
    # Git aliases
    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";
    # NixOS rebuild aliases (uses current host)
    nrt = "cd ~/linux-dotfiles/nixos && sudo nixos-rebuild test --flake .#${host.flakeTarget}";
    nrs = "cd ~/linux-dotfiles && git add . && cd nixos && sudo nixos-rebuild switch --flake .#${host.flakeTarget}";
    # Docker Compose aliases
    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcd = "docker compose down";
    dcdv = "docker compose down -v";

    dotfiles = "cd ~/linux-dotfiles";

    # calcurse alias to read from /home/quesadx/obsidian-vault/calcurse/
    calcurse = "calcurse -D /home/${username}/obsidian-vault/08-calcurse/";
  };

  # ─── USER PACKAGES ────────────────────────────────────────────────────────
  userPackages = with pkgs; [
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
  ];

  # ─── VS CODE EXTENSIONS ────────────────────────────────────────────────────
  vscode-extensions-enabled = with pkgs.vscode-extensions; [
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

  # ─── CONFIG FILE SOURCES ───────────────────────────────────────────────────
  configSources = {
    # "fastfetch".source = ../../config/active/fastfetch;
  };

in

# ─── HOME MANAGER CONFIGURATION ────────────────────────────────────────────

{
  # Desktop-specific user settings (e.g. GNOME dconf) are loaded via
  # hosts.nix → homeModules → flake.nix. No DE imports belong here.

  # ─── HOME MANAGER METADATA ─────────────────────────────────────────────────
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "26.05";
  home.packages = userPackages;
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  # ─── SYSTEM SERVICES ───────────────────────────────────────────────────────
  services.ssh-agent.enable = true;
  xdg.configFile = configSources;

  # ─── SHELL: ZSH & BASH ─────────────────────────────────────────────────────
  programs.starship.enable = true;
  programs.zsh.enable = true;
  programs.zsh.shellAliases = bashAliases;

  programs.bash.enable = true;
  programs.bash.shellAliases = bashAliases;

  # ─── VERSION CONTROL: GIT ──────────────────────────────────────────────────
  programs.git.enable = true;
  programs.git.package = pkgs.gitFull;
  programs.git.settings.user = gitUser;
  programs.git.settings.init.defaultBranch = "main";
  programs.git.settings.pull.rebase = true;
  programs.git.settings.credential.helper = "libsecret";

  # ─── ENVIRONMENT MANAGEMENT: DIRENV ────────────────────────────────────────
  programs.direnv.enable = true;
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  # ─── SSH CONFIGURATION ─────────────────────────────────────────────────────
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings."*".addKeysToAgent = "yes";

  # ─── EDITOR: ZED ──────────────────────────────────────────────────────────
  programs.zed-editor.enable = true;
  programs.zed-editor.extensions = [
    "java"
    "dockerfile"
    "sql"
    "opencode"
    "nix"
    "prisma"
    "docker-compose"
    "ini"
    "pylsp"
    "xml"
  ];
  programs.zed-editor.extraPackages = with pkgs; [
    nil
    nixd
    opencode
  ];

  # ─── EDITOR: VS CODE ───────────────────────────────────────────────────────
  programs.vscode.enable = true;
  programs.vscode.profiles.default.extensions = vscode-extensions-enabled;
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
  # ─── CHROMIUM ────────────────────────────────────────────────────────────────
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };
}
