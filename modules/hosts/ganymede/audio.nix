{
  flake.nixosModules.ganymedeAudio = {
    lib,
    pkgs,
    ...
  }: {
    hardware.firmware = [
      (pkgs.runCommand "legion-audio-patch" {
          src = ./audio-fix/firmware/aw88399_acf.bin;
        } ''
          mkdir -p $out/lib/firmware
          cp -f $src $out/lib/firmware/aw88399_acf.bin
        '')
    ];

    boot.kernelPatches = [
      {
        name = "16iax10h-audio-linux-6.19.11";
        patch = ./audio-fix/patches/16iax10h-audio-linux-6.19.11.patch;

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
  };
}
