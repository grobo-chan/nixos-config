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
    boot.kernelModules = ["kvm-intel" "rtw89" "igc" "uinput"];
    boot.extraModulePackages = [];

    boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_7_0.override {
      argsOverride = rec {
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v7.x/linux-${version}.tar.xz";
          sha256 = "sha256-u39tgLOHx1e30Uu5MCj8uQ95PFwNNnc27oFaEAs4kfA=";
        };
        version = "7.0";
        modDirVersion = "7.0.0";
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

    swapDevices = [];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
