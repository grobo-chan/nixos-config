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
                  hash = "sha256-1vV9UsWlvYb1+1RwtB57DTYoA7jW9dYjBOU8rabnqvE=";
                }).outPath
                (pkgs.fetchpatch2 {
                  url = "https://coca.codes/no-override-tilde.patch";
                  hash = "sha256-xD3QL69dUYMnlUjiC6NE6hFrUragdBXlMJCv5o4Vqww=";
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
