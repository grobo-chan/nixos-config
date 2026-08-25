{
  flake.nixosModules.hostVM = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    boot.initrd.availableKernelModules = ["ata_piix" "xhci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.extraModulePackages = [];

    boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-partlabel/disk-main-luks";

    fileSystems."/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/disk-main-ESP";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    fileSystems."/cache" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = ["subvol=cache"];
    };

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

    swapDevices = [];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
