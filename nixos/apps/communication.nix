{
  flake.nixosModules.communication = {pkgs, ...}: {
    nixpkgs.overlays = [
      (final: prev: {
        deltachat-desktop =
          prev.deltachat-desktop.overrideAttrs
          (oldAttrs: {
            # Plural patches for DeltaChat
            # See this: https://coca.codes/plural-delta/
            patches =
              (oldAttrs.patches or [])
              ++ [
                (pkgs.fetchpatch2 {
                  url = "https://coca.codes/override-name.patch";
                  hash = "sha256-Q49opq4Ebnqz5U23+0dok/nOOotPd+FchcD89GAGeZ0=";
                }).outPath
                (pkgs.fetchpatch2 {
                  url = "https://coca.codes/no-override-tilde.patch";
                  hash = "sha256-G5M/7eatHTFj5dSTOt8HJUvAb4rT73IQzmjr80m+xC0=";
                }).outPath
              ];
          });
      })
    ];

    environment.systemPackages = with pkgs; [
      deltachat-desktop
      vesktop
      thunderbird
    ];

    persistance.user.directories = [
      ".config/vesktop"
      ".config/DeltaChat"
    ];
  };
}
