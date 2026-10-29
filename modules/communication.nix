{
  sources,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (deltachat-desktop.overrideAttrs (oldAttrs: {
      patches =
        (oldAttrs.patches or [])
        ++ [
          # sources.delta-no-override-tilde-patch
          # sources.delta-override-name-patch

          /*
          * Newer patch by @coca162 which isn't exactly upstream yet
          * Works on Deltachat v2.65.0
          * Allows you to proxy similarly to PK on discord after you copy `pk;export` output to the clipboard

          TODO: Add pk-delta.patch to tacks once all this is actually hosted on https://coca.codes/plural-delta/patches
          Also, I dunno if I have permission to make said patches public, so the folder was .gitignore'd for now
          */
          ./delta-patches/no-override-tilde.patch
          ./delta-patches/override-name.patch
          ./delta-patches/pk-delta.patch
        ];
    }))
    vesktop
    thunderbird
  ];

  persistance.user.directories = [
    ".config/vesktop"
    ".config/DeltaChat"
    ".config/thunderbird"
  ];

  persistance.user.cache.directories = [
    ".cache/thunderbird"
  ];
}
