{
  flake.nixosModules.hostEuropa = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "rtsx_usb_sdmmc"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
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
      device = "/dev/disk/by-uuid/57f5e02a-7418-4ba3-9f3f-3ee3537abd00";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/4388-7609";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
