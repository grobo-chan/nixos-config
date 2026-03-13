{
  flake.nixosModules.hostGanymede = {
    lib,
    pkgs,
    ...
  }: let
    patchedAlsaUcm = pkgs.alsa-ucm-conf.overrideAttrs (oldAttrs: {
      postInstall =
        (oldAttrs.postInstal or "")
        + ''
          mkdir -p $out/share/alsa/ucm2/HDA
          cp ${./audio-fix/ucm2/HiFi-analog.conf} $out/share/alsa/ucm2/HDA/HiFi-analog.conf
          cp ${./audio-fix/ucm2/HiFi-mic.conf} $out/share/alsa/ucm2/HDA/HiFi-mic.conf
        '';
    });
  in {
    systemd.user.services.audio-patch = {
      description = "Audio patch for the Lenovo Legion 16IAX10H";
      serviceConfig.PassEnvironment = "DISPLAY";
      script = with pkgs; ''
        ${alsa-utils}/bin/alsaucm -c hw:1 reset
        ${alsa-utils}/bin/alsaucm -c hw:1 reload
        systemctl --user restart pipewire pipewire-pulse wireplumber
        ${alsa-utils}/bin/amixer sset -c 1 Master 100%
        ${alsa-utils}/bin/amixer sset -c 1 Headphone 100%
        ${alsa-utils}/bin/amixer sset -c 1 Speaker 100%
      '';
    };

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
        name = "16iax10h-audio-linux-6.19";
        patch = ./audio-fix/patches/16iax10h-audio-linux-6.19.patch;

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
    boot.kernelParams = ["snd_intel_dspcfg.dsp_driver=3"];
    environment.variables.ALSA_CONFIG_UCM2 = "${patchedAlsaUcm}/share/alsa/ucm2";
  };
}
