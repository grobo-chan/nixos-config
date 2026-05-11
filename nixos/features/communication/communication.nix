{
  flake.nixosModules.communication = {pkgs, ...}: {
    nixpkgs.overlays = [
      (final: prev: {
        deltachat-desktop =
          prev.deltachat-desktop.overrideAttrs
          (oldAttrs: {
            patches = (oldAttrs.patches or []) ++ [./delta-patches/override-name.patch ./delta-patches/no-override-tilde.patch];
          });
      })
    ];

    environment.systemPackages = with pkgs; [
      deltachat-desktop
      vesktop
      thunderbird
    ];
  };
}
