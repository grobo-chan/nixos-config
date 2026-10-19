{
  config,
  lib,
  pkgs,
  sources,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    "${sources.grobo-hardware}/lenovo/legion/16iax10h"
    ./audio.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "rtw89" "igc" "uinput"];
  boot.kernelParams = [];
  boot.extraModulePackages = [];

  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_7_2.override {
  #   argsOverride = rec {
  #     src = pkgs.fetchurl {
  #           url = "mirror://kernel/linux/kernel/v7.x/linux-${version}.tar.xz";
  #           sha256 = "sha256-L+qnBFPpH1Qb5qXJB42BaOCBr0Wj2XGAVIUFOM/y6/M=";
  #     };
  #     version = "7.2.10";
  #     modDirVersion = version;
  #     };
  # });

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
