{
  flake.nixosModules.creative = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gimp
      krita
      obs-studio
      kdePackages.kdenlive

      libsForQt5.xp-pen-deco-01-v2-driver
    ];
  };
}
