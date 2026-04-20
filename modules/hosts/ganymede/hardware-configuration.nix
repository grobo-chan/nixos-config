{self, ...}: {
  flake.nixosModules.hostGanymede = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      self.nixosModules.ganymedeAudio
    ];

    boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel" "rtw89" "igc"];
    boot.extraModulePackages = [];

    boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_19.override {
      argsOverride = rec {
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
          sha256 = "sha256-IAOde2slbAi+L4+sQ8P/mmIDCMcDxkPPL4DDkQub1Zs=";
        };
        version = "6.19.11";
        modDirVersion = "6.19.11";
      };
    });

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/9adc18c6-602e-460b-b128-5fcbb22cfcbb";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/EED8-A26E";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    fileSystems."/mnt/windows-disk" = {
      device = "/dev/nvme0n1p3";
      fsType = "auto";
      options = ["noatime" "x-systemd.automount" "x-systemd.device-timeout=10" "x-systemd.idle-timeout=1min"];
    };

    systemd.tmpfiles.rules = ["d /mnt/windows-disk 0777 grobo wheel"];

    swapDevices = [];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
