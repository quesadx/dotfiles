{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  ...
}:

let
  projectDir = "/home/quesadx/cloud-selfhost";
  envFile = "${projectDir}/.env";
  hddUuid = "60caac08-c6b7-4fab-87db-c5d47535bf41";
in
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "thinkpad-x13-gen2";

  # --- Hardware ---
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/SWAP"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # --- Headless server ---
  services.displayManager.enable = false;
  hardware.bluetooth.powerOnBoot = false;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  # Cap charge at 65% to extend battery lifespan.
  systemd.services.thinkpad-battery-limit = {
    description = "Cap ThinkPad battery charge at 65%";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-module-thinkpad_acpi.device" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo 65 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
  };

  services.flatpak.enable = lib.mkForce false;

  # --- Docker ---
  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    util-linux
    e2fsprogs
    hdparm
    restic
  ];

  # --- Backup HDD: mounted on demand, never left spinning ---
  fileSystems."/mnt/backup-hdd" = {
    device = "/dev/disk/by-uuid/${hddUuid}";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10min"
      "x-systemd.device-timeout=120s"
      "x-systemd.mount-timeout=120s"
    ];
  };

  # --- Restic backup ---
  systemd.services.restic-backup = {
    description = "Restic backup of cloud-selfhost to external HDD";
    after = [ "docker.service" ];
    wants = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      TimeoutStartSec = "6h";
      ExecStartPre = pkgs.writeShellScript "restic-backup-mount" ''
        set -euo pipefail
        if ! ${pkgs.util-linux}/bin/mountpoint -q /mnt/backup-hdd; then
          ${pkgs.util-linux}/bin/mount /mnt/backup-hdd
        fi
        ${pkgs.coreutils}/bin/test -f /mnt/backup-hdd/.backup-hdd-marker
      '';
      ExecStopPost = pkgs.writeShellScript "restic-backup-umount" ''
        ${pkgs.coreutils}/bin/sync
        # Stop the mount unit, never raw umount: raw umount tears down the
        # autofs and leaves /mnt/backup-hdd as a plain NVMe directory.
        ${pkgs.systemd}/bin/systemctl stop \
          "$(${pkgs.systemd}/bin/systemd-escape -p --suffix=mount /mnt/backup-hdd)" 2>/dev/null || true
        ${pkgs.hdparm}/bin/hdparm -y "$(${pkgs.coreutils}/bin/readlink -f /dev/disk/by-uuid/${hddUuid})" 2>/dev/null || true
      '';
      ExecStart = pkgs.writeShellScript "restic-backup" ''
        set -euo pipefail
        export PATH="${pkgs.restic}/bin:${pkgs.docker}/bin:${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.findutils}/bin:${pkgs.util-linux}/bin:$PATH"

        log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

        REPO="/mnt/backup-hdd/restic-repo"
        SOURCE="${projectDir}"
        DB_CONTAINER="cloud-selfhost-db-1"
        DB_DUMP_DIR="$SOURCE/data/db-backup"

        if ! mountpoint -q /mnt/backup-hdd || ! test -f /mnt/backup-hdd/.backup-hdd-marker; then
          log "FATAL: /mnt/backup-hdd is not the backup HDD; refusing to run"
          exit 1
        fi

        export RESTIC_REPOSITORY="$REPO"
        export RESTIC_PASSWORD="$(grep '^RESTIC_PASSWORD=' "${envFile}" | cut -d= -f2-)"
        PGPASSWORD="$(grep '^POSTGRES_PASSWORD=' "${envFile}" | cut -d= -f2-)"

        # cat config does not lock, so stale locks cannot abort this check.
        if ! restic cat config >/dev/null 2>&1; then
          log "Initializing restic repo..."
          restic init
        else
          log "Clearing stale restic locks..."
          restic unlock
        fi

        # Nextcloud's config.php is read-only, so pg_dump is our consistency point.
        log "Dumping Postgres..."
        mkdir -p "$DB_DUMP_DIR"
        DUMP="$DB_DUMP_DIR/nextcloud-$(date +%Y%m%d-%H%M%S).dump"
        if ! docker exec -e PGPASSWORD="$PGPASSWORD" "$DB_CONTAINER" \
             pg_dump -U nextcloud -Fc nextcloud > "$DUMP"; then
          log "FATAL: pg_dump failed; aborting so no truncated dump is backed up"
          rm -f "$DUMP"
          exit 1
        fi
        find "$DB_DUMP_DIR" -name 'nextcloud-*.dump' -mtime +7 -delete

        VW_DB="$SOURCE/data/vaultwarden/db.sqlite3"
        VW_DUMP="$DB_DUMP_DIR/vaultwarden-$(date +%Y%m%d-%H%M%S).sqlite3"
        if [ -f "$VW_DB" ]; then
          log "Backing up Vaultwarden sqlite..."
          ${pkgs.sqlite}/bin/sqlite3 "$VW_DB" ".backup '$VW_DUMP'"
          if [ "$(${pkgs.sqlite}/bin/sqlite3 "$VW_DUMP" 'pragma integrity_check;')" != "ok" ]; then
            log "FATAL: vaultwarden sqlite integrity check failed"
            exit 1
          fi
          find "$DB_DUMP_DIR" -name 'vaultwarden-*.sqlite3' -mtime +7 -delete
        else
          log "WARN: no vaultwarden db at $VW_DB; skipping sqlite backup"
        fi

        log "Validating Postgres dump..."
        if ! docker exec -i "$DB_CONTAINER" pg_restore --list < "$DUMP" >/dev/null; then
          log "FATAL: nextcloud pg_dump archive is invalid"
          exit 1
        fi

        log "Running restic backup..."
        restic backup "$SOURCE" \
          --exclude "$SOURCE/data/db" \
          --exclude "$SOURCE/data/redis" \
          --exclude "$SOURCE/data/vaultwarden/db.sqlite3" \
          --exclude "$SOURCE/data/vaultwarden/db.sqlite3-wal" \
          --exclude "$SOURCE/data/vaultwarden/db.sqlite3-shm" \
          --exclude "$SOURCE/.git" \
          --exclude "$SOURCE/data/*/cache"

        log "Forgetting/pruning old snapshots..."
        restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune

        log "Backup complete"
      '';
    };
  };

  systemd.timers.restic-backup = {
    description = "Daily restic backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "03:00";
      Persistent = true;
    };
  };

  # --- Monthly integrity check ---
  systemd.services.restic-check = {
    description = "Restic repository integrity check";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = pkgs.writeShellScript "restic-check" ''
        set -euo pipefail
        export PATH="${pkgs.restic}/bin:${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.util-linux}/bin:$PATH"

        if ! ${pkgs.util-linux}/bin/mountpoint -q /mnt/backup-hdd; then
          ${pkgs.util-linux}/bin/mount /mnt/backup-hdd
        fi
        ${pkgs.coreutils}/bin/test -f /mnt/backup-hdd/.backup-hdd-marker

        export RESTIC_REPOSITORY="/mnt/backup-hdd/restic-repo"
        export RESTIC_PASSWORD="$(${pkgs.gnugrep}/bin/grep '^RESTIC_PASSWORD=' "${envFile}" | ${pkgs.coreutils}/bin/cut -d= -f2-)"

        restic check --read-data-subset=10%
      '';
      ExecStopPost = pkgs.writeShellScript "restic-check-umount" ''
        ${pkgs.coreutils}/bin/sync
        ${pkgs.systemd}/bin/systemctl stop \
          "$(${pkgs.systemd}/bin/systemd-escape -p --suffix=mount /mnt/backup-hdd)" 2>/dev/null || true
        ${pkgs.hdparm}/bin/hdparm -y "$(${pkgs.coreutils}/bin/readlink -f /dev/disk/by-uuid/${hddUuid})" 2>/dev/null || true
      '';
    };
  };

  systemd.timers.restic-check = {
    description = "Monthly restic integrity check";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
    };
  };
}
