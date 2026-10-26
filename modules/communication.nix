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
          sources.delta-no-override-tilde-patch
          sources.delta-override-name-patch
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
