{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./audio.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "rtw89" "igc" "uinput"];
  boot.kernelParams = [];
  boot.extraModulePackages = [];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Incase I need to pin for whatever reason
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_7_0.override {
  #   argsOverride = rec {
  #     src = pkgs.fetchurl {
  #       url = "mirror://kernel/linux/kernel/v7.x/linux-${version}.tar.xz";
  #       sha256 = "sha256-PIHt0PcWrKPdSN/2kWgYJ1gMxT01qO7DvkfTRtH4mRM=";
  #     };
  #     version = "7.0.13";
  #     modDirVersion = "7.0.13";
  #   };
  # });

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
