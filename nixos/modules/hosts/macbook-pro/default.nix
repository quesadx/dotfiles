{ pkgs, lib, ... }:
{
  boot.initrd.systemd.enable = true;

  boot.initrd.kernelModules = [ "coretemp" "applesmc" ];

  boot.kernelParams = [
    "i915.enable_dc=2" # deep display power states
    "nvme_core.default_ps_max_latency_us=0"
    "mitigations=off"
    "transparent_hugepage=madvise"
  ];

  boot.blacklistedKernelModules = [ "btusb" ];

  # NOTE: swap partition must be >= RAM for hibernation to work
  boot.resumeDevice = "/dev/disk/by-label/swap";

  # ─── HIBERNATION ─────────────────────────────────────────────────────────
  systemd.sleep.settings.Sleep = {
    AllowSuspend             = false;
    AllowHybridSleep         = false;
    AllowSuspendThenHibernate = false;
    AllowHibernation         = true;
    HibernateMode            = "shutdown";
  };

  # ─── LID → HIBERNATE ─────────────────────────────────────────────────────
  services.logind.settings.Login = {
    HandleLidSwitch         = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
    HandleSuspendKey        = "hibernate";
  };

  # ─── WIFI MODULE: unload before hibernate, reload on resume ──────────────
  powerManagement.powerDownCommands = ''
    ${pkgs.kmod}/bin/modprobe -r brcmfmac_wcc || true
    ${pkgs.kmod}/bin/modprobe -r brcmfmac     || true
    ${pkgs.kmod}/bin/modprobe -r brcmutil     || true
  '';
  powerManagement.resumeCommands = ''
    sleep 3
    ${pkgs.kmod}/bin/modprobe brcmfmac
  '';

  # ─── PREVENT USB WAKEUP AFTER HIBERNATE ──────────────────────────────────
  services.udev.extraRules = ''
    SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
  '';

  # ─── FAN CONTROL ─────────────────────────────────────────────────────────
  services.mbpfan = {
    enable = true;
    settings.general = {
      min_fan1_speed = 1300;
      max_fan1_speed = 6000;
      low_temp  = 48;
      high_temp = 68;
      max_temp  = 86;
    };
  };

  # ─── TLP ─────────────────────────────────────────────────────────────────
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC      = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT     = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC    = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT   = "balance_performance";
      CPU_BOOST_ON_AC                 = 1;
      CPU_BOOST_ON_BAT                = 1;
      CPU_HWP_DYN_BOOST_ON_AC         = 1;
      CPU_HWP_DYN_BOOST_ON_BAT        = 1;
      CPU_MIN_PERF_ON_AC              = 11;
      CPU_MAX_PERF_ON_AC              = 100;
      CPU_MIN_PERF_ON_BAT             = 20;
      CPU_MAX_PERF_ON_BAT             = 85;

      DISK_APM_LEVEL_ON_AC            = "255 255";
      DISK_APM_LEVEL_ON_BAT           = "128 128";
      DISK_IOSCHED                    = "none mq-deadline";

      WIFI_PWR_ON_AC                  = "off";
      WIFI_PWR_ON_BAT                 = "off";
      BLUETOOTH_PWR_ON_AC             = "on";
      BLUETOOTH_PWR_ON_BAT            = "off";
      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth";

      RUNTIME_PM_ON_AC                = "on";
      RUNTIME_PM_ON_BAT               = "auto";
      USB_AUTOSUSPEND                 = 1;

      SCHED_POWERSAVE_ON_AC           = 0;
      SCHED_POWERSAVE_ON_BAT          = 0;
    };
  };
}