{ pkgs, lib, ... }:
{

  boot.initrd.systemd.enable = true;
  
  boot.initrd.kernelModules = [
    "coretemp"
    "applesmc"
  ];

  boot.kernelParams = [
    # S3 deep sleep crashea en Apple EFI; s2idle es el único modo funcional
    # pero también es inestable — se usa solo como paso intermedio a hibernate
    "mem_sleep_default=s2idle"
    "i915.enable_psr=0"
    "nvme_core.default_ps_max_latency_us=0"
  ];

  boot.blacklistedKernelModules = [
    "btusb"
  ];

    powerManagement.powerDownCommands = ''
    ${pkgs.kmod}/bin/modprobe -r brcmfmac_wcc || true
    ${pkgs.kmod}/bin/modprobe -r brcmfmac || true
    ${pkgs.kmod}/bin/modprobe -r brcmutil || true
  '';

    powerManagement.resumeCommands = ''
    sleep 3
    ${pkgs.kmod}/bin/modprobe brcmfmac
  '';

  # ─── RESUME DESDE HIBERNACIÓN ─────────────────────────────────────────────
  boot.resumeDevice = "/dev/disk/by-uuid/c0e5d438-f519-4894-872c-d6471ea518da";
  # Si usas swapfile (no partición swap), también necesitas:
  # boot.kernelParams = [ ... "resume_offset=XXXXXXX" ];
  # Obtén el offset con: filefrag -v /ruta/swapfile | awk 'NR==4{print $4}' | tr -d '.'

  # ─── SLEEP: SOLO HIBERNATE, SUSPEND DESHABILITADO ─────────────────────────
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
    AllowHibernation = true;

    HibernateMode = "shutdown";
  };

  # ─── LID → HIBERNATE ──────────────────────────────────────────────────────
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
    HandleSuspendKey = "hibernate";     # botón de suspend también → hibernate
  };

  # ─── WAKEUP: DESHABILITAR USB PARA EVITAR WAKE INMEDIATO ──────────────────
  # El subsistema USB puede despertar el Mac inmediatamente después de hibernar
  services.udev.extraRules = ''
    SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
  '';

  # ─── FAN CONTROL ──────────────────────────────────────────────────────────
  services.mbpfan = {
    enable = true;
    settings.general = {
      min_fan1_speed = 1200;
      max_fan1_speed = 6000;
      low_temp = 55;
      high_temp = 75;
      max_temp = 92;
    };
  };

  # ─── TLP ──────────────────────────────────────────────────────────────────
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
      BLUETOOTH_PWR_ON_AC = "on";
      BLUETOOTH_PWR_ON_BAT = "on";
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 1;
    };
  };
}