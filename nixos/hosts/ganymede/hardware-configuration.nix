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
    boot.kernelPackages = pkgs.linuxPackages_7_0;

    boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-partlabel/disk-main-luks";

    fileSystems."/nix" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    fileSystems."/persistent" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=persistent"];
    };

    fileSystems."/persistent/swap" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=persistent/swap"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/disk-main-ESP";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.npu.enable = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
