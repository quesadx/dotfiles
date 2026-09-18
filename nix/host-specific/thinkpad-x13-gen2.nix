{ pkgs, lib, ... }:

let
  projectDir = "/home/quesadx/cloud-selfhost";
  envFile = "${projectDir}/.env";
  hddUuid = "60caac08-c6b7-4fab-87db-c5d47535bf41";
in
{
  # --- TTY only, no DE/WM ---
  services.displayManager.enable = false;

  # --- Headless server: never suspend on lid close ---
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  # --- Battery: cap charge at 65% to extend lifespan ---
  systemd.services.thinkpad-battery-limit = {
    description = "Cap ThinkPad battery charge at 65%";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-module-thinkpad_acpi.device" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo 65 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
  };

  # --- No desktop, so no flatpak/portals ---
  services.flatpak.enable = lib.mkForce false;

  # --- Docker & compose ---
  environment.systemPackages = with pkgs; [
    docker-compose
    util-linux
    e2fsprogs
    hdparm
    restic
  ];

  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
  };

  # --- External backup HDD: mounted only on demand, never left spinning ---
  # x-systemd.automount mounts it on access and unmounts after 10 min idle.
  # nofail means a missing disk never blocks boot; the backup service mounts
  # it explicitly and hard-fails if the marker file is absent, so a backup can
  # never silently land on the NVMe.
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
        # Stop the mount *unit*, never raw `umount`: raw umount tears down the
        # autofs, leaving /mnt/backup-hdd as a plain NVMe dir (fall-through).
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

        if ! restic snapshots >/dev/null 2>&1; then
          log "Initializing restic repo..."
          restic init
        fi

        log "Clearing stale restic locks..."
        restic unlock

        # NB: Nextcloud's config.php is read-only by design, so occ maintenance
        # mode cannot be toggled; the -Fc pg_dump below is the consistency point.
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

        # Vaultwarden is the most critical service: take an online SQLite backup
        # (safe while running, unlike copying the live db/wal) and verify it.
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

  # --- Monthly integrity check (reads 10% of the data) ---
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
        # Stop the mount unit (keeps autofs alive); see restic-backup ExecStopPost.
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
