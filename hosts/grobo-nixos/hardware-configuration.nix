{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  analogConf = builtins.readFile ./ucm2/HiFi-analog.conf;
  micConf = builtins.readFile ./ucm2/HiFi-mic.conf;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "rtw89" "igc"];
  boot.extraModulePackages = [];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.firmware = [
    (pkgs.runCommand "legion-audio-patch" {
        src = ./aw88399_acf.bin;
      } ''
        mkdir -p $out/lib/firmware
        cp -f $src $out/lib/firmware/aw88399_acf.bin
      '')
  ];

  boot.kernelPatches = [
    {
      name = "16iax10h-audio-linux-6.18";
      patch = ./16iax10h-audio-linux-6.18.patch;

      structuredExtraConfig = with lib.kernel; {
        SND_HDA_SCODEC_AW88399 = module;
        SND_HDA_SCODEC_AW88399_I2C = module;
        SND_SOC_AW88399 = module;
        SND_SOC_SOF_INTEL_TOPLEVEL = yes;
        SND_SOC_SOF_INTEL_COMMON = module;
        SND_SOC_SOF_INTEL_MTL = module;
        SND_SOC_SOF_INTEL_LNL = module;
      };
    }
  ];

  hardware.alsa = {
    enablePersistence = true;
    config = "${analogConf}\n${micConf}";
  };

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
}
