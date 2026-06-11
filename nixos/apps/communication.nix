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
                  hash = "sha256-jCfTajaI2fCvq5JWjmU/Csr8+CJi+F6Wy28JHSp/KcU=";
                }).outPath
                (pkgs.fetchpatch2 {
                  url = "https://coca.codes/no-override-tilde.patch";
                  hash = "sha256-7Z82CGHsBtQEuLqRp1TSkfixQngBZwt/B77Gqiar5wo=";
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
