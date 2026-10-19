{
  pkgs,
  sources,
  ...
}: {
  hardware.firmware = [
    (
      pkgs.runCommand "legion-audio-patch" {
        src = "${sources.audio-16iax10h}/fix/firmware/aw88399_acf.bin";
      } ''
        mkdir -p $out/lib/firmware
        cp -f $src $out/lib/firmware/aw88399_acf.bin
      ''
    )
  ];
}
